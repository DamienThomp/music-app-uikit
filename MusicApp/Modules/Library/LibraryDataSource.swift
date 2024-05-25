//
//  LibraryDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import Foundation

enum LibrarSections: Hashable, CaseIterable {

    case albums
    case playlists
    case artists

    var title: String {

        switch self {
        case .albums:
            "Albums"
        case .playlists:
            "Playlists"
        case .artists:
            "Followed Artists"
        }
    }
}

protocol LibraryDataSourceDelegate: AnyObject {

    @MainActor func didLoadData(for section: LibrarSections, with data: Codable)
    @MainActor func didFinishLoading()
}

class LibraryDataSource {

    private let decoder: JSONDecoder = {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }()

    private var authManager: AuthManager?
    private var networkManager: NetworkManager?

    weak var delegate: LibraryDataSourceDelegate?
}

//MARK: - Data Fetching
extension LibraryDataSource {

    private func fetchSavedAlbums() async throws -> AlbumsResponse {

        let data = try await executeRequest(
            for: UsersSavedItems.albums(
                limit: 25
            )
        )

        return try decoder.decode(AlbumsResponse.self, from: data)
    }

    private func fetchSavedPLaylists() async throws -> SavedPlaylistsResponse {

        let data = try await executeRequest(
            for: UsersSavedItems.playlists(
                limit: 25
            )
        )

        return try decoder.decode(SavedPlaylistsResponse.self, from: data)
    }

    private func fetchSavedArtists() async throws -> SavedArtistsResponse {

        let data = try await executeRequest(
            for: UsersSavedItems.following(
                limit: 25,
                type: .artist
            )
        )

        return try decoder.decode(SavedArtistsResponse.self, from: data)
    }

    private func executeRequest(for endPoint: EndpointProtocol) async throws -> Data {

        guard let networkManager else {
            throw ServiceResolverErrors.failedToResolveService
        }

        return try await networkManager.request(for: endPoint)
    }

    func fetchDispayData() {

        Task {

            do {
                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                try await withThrowingTaskGroup(of: Void.self) { taskGroup in

                    taskGroup.addTask {
                        let savedAlbums = try await self.fetchSavedAlbums()
                        await self.delegate?.didLoadData(for: .albums, with: savedAlbums)
                    }

                    taskGroup.addTask {
                        let savedPlaylists = try await self.fetchSavedPLaylists()
                        await self.delegate?.didLoadData(for: .playlists, with: savedPlaylists)
                    }

                    taskGroup.addTask {
                        let savedArtists = try await self.fetchSavedArtists()
                        await self.delegate?.didLoadData(for: .artists, with: savedArtists)
                    }

                    try await taskGroup.waitForAll()
                    
                    await self.delegate?.didFinishLoading()
                }

            } catch {
                #warning("add error handling")
                print(error)
            }
        }
    }
}

//MARK: - Service Resolver
extension LibraryDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
