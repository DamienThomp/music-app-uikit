//
//  ArtistDetailsDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import Foundation

protocol ArtistDetailsDataSourceDelegate: AnyObject {

    @MainActor func didLoadData(for sectionType: ArtistDetailSection, with data: Codable)
    @MainActor func didLoadHeader(with data: ArtistDetailsResponse)
    @MainActor func didFinishLoading()
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didUpdateSavedStatus()
    @MainActor func didFailToSaveItem()
}

class ArtistDetailsDataSource {

    private let decoder: JSONDecoder = {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }()

    private var authManager: AuthManager?
    private var networkManager: NetworkManager?

    weak var delegate: ArtistDetailsDataSourceDelegate?

    var isFollowingArtist: Bool = false
}

// MARK: - Data Fetching
extension ArtistDetailsDataSource {

    private func getArtistDetails(for id: String) async throws -> ArtistDetailsResponse {
        print("getArtistDetails")
        let artistEndpoint = ArtistEndpoint.artist(id: id)
        let responseData = try await executeRequest(for: artistEndpoint)
        return try decoder.decode(ArtistDetailsResponse.self, from: responseData)
    }

    private func getArtistAlbums(for id: String) async throws -> ArtistAlbumsResponse {

        let artistAlbumsEndpoint = ArtistEndpoint.albums(
            id: id,
            includeGroup: [
                .single,
                .album,
                .compilation
            ]
        )
        let responseData = try await executeRequest(for: artistAlbumsEndpoint)
       // let json = try? JSONSerialization.jsonObject(with: responseData, options: [])
       return try decoder.decode(ArtistAlbumsResponse.self, from: responseData)
    }

    private func getArtistTopTracks(for id: String) async throws -> TrackResponse {

        let artistTopTracksEndpoint = ArtistEndpoint.topTracks(id: id)
        let responseData = try await executeRequest(for: artistTopTracksEndpoint)
        return try decoder.decode(TrackResponse.self, from: responseData)
    }

    private func executeRequest(for endPoint: EndpointProtocol) async throws -> Data {

        guard let networkManager else {
            throw ServiceResolverErrors.failedToResolveService
        }

        return try await networkManager.request(for: endPoint)
    }

    func fetchDisplayData(for id: String) {

        Task {
            do {
                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                try await withThrowingTaskGroup(of: Void.self) { taskGroup in

                    taskGroup.addTask {
                        let response = try await self.getArtistDetails(for: id)
                        await self.delegate?.didLoadHeader(with: response)
                    }

                    taskGroup.addTask {
                        let response = try await self.getArtistAlbums(for: id)
                        await self.delegate?.didLoadData(for: .albums, with: response)
                    }

                    taskGroup.addTask {
                        let response = try await self.getArtistTopTracks(for: id)
                        await self.delegate?.didLoadData(for: .tracks, with: response)
                    }

                    try await taskGroup.waitForAll()
                    await self.delegate?.didFinishLoading()
                }
            } catch {
                print(
                    error
                )
                await delegate?.didFailLoading(with: error)
            }
        }
    }
}

// MARK: - Service Resolver
extension ArtistDetailsDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
