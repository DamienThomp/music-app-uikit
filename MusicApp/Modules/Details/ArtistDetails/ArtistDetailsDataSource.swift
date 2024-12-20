//
//  ArtistDetailsDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import Foundation

protocol ArtistDetailsDataSourceDelegate: AnyObject {

    @MainActor func didLoadData(for sectionType: ArtistDetailSectionType, with data: Codable)
    @MainActor func didFinishLoading()
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didUpdateFollowedStatus()
    @MainActor func didFailToFollowArtist()
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

    var isFollowingArtist: Bool = false {
        didSet {
            Task { @MainActor in
                delegate?.didUpdateFollowedStatus()
            }
        }
    }
}

// MARK: - Data Fetching
extension ArtistDetailsDataSource {

    private func getIsFollowedStatus(for id: String) async throws -> [Bool] {

        let endPoint = ArtistEndpoint.contains(ids: [id])
        let responseData = try await executeRequest(for: endPoint)

        return try decoder.decode([Bool].self, from: responseData)
    }

    func followArtist(with id: String) async throws {

        let endPoint = UsersSavedItems.follow(ids: [id])
        _ = try await executeRequest(for: endPoint)
    }

    func unFollowArtist(with id: String) async throws {

        let endPoint = UsersSavedItems.unfollow(ids: [id])
        _ = try await executeRequest(for: endPoint)
    }

    private func getArtistDetails(for id: String) async throws -> ArtistDetailsResponse {

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

    func updateFollowStatus(with id: String) {

        Task { @MainActor in

            do {
                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                if isFollowingArtist {
                    try await unFollowArtist(with: id)
                    isFollowingArtist = false
                } else {
                    try await followArtist(with: id)
                    isFollowingArtist = true
                }
                delegate?.didUpdateFollowedStatus()
            } catch {
                delegate?.didFailToFollowArtist()
            }
        }
    }

    func fetchDisplayData(for id: String) {

        Task {
            do {
                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                let response = try await self.getArtistDetails(for: id)
                await self.delegate?.didLoadData(for: .main, with: response)

                let trackResponse = try await self.getArtistTopTracks(for: id)
                await self.delegate?.didLoadData(for: .tracks, with: trackResponse)

                let albumsResponse = try await self.getArtistAlbums(for: id)
                await self.delegate?.didLoadData(for: .album, with: albumsResponse)

                let isFollowingResponse = try await self.getIsFollowedStatus(for: id)

                if let responseValue = isFollowingResponse.first {
                    print("response: \(responseValue)")
                    self.isFollowingArtist = responseValue
                }

                await self.delegate?.didFinishLoading()
            } catch {
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
