//
//  LibraryDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import Foundation

protocol LibraryDataSourceDelegate: AnyObject {

    @MainActor func didLoadData(for section: LibrarySections, with data: Codable)
    @MainActor func didFinishLoading()
    @MainActor func didFailLoading(with error: Error)
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

    private let fetchLimit = 30
}

// MARK: - Data Fetching
extension LibraryDataSource {

    private func executeRequest<T: Codable>(
        for endPoint: EndpointProtocol,
        of type: T.Type
    ) async throws -> T {

        guard let networkManager else {
            throw ServiceResolverErrors.failedToResolveService
        }

        let data = try await networkManager.request(for: endPoint)

        return try decoder.decode(T.self, from: data)
    }

    func fetchDispayData() {

        Task {

            do {

                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                try await withThrowingTaskGroup(of: Void.self) { taskGroup in

                    taskGroup.addTask {

                        let endPoint = UsersSavedItems.albums(limit: self.fetchLimit)
                        let savedAlbums = try await self.executeRequest(
                            for: endPoint,
                            of: AlbumsResponse.self
                        )
                        await self.delegate?.didLoadData(for: .albums, with: savedAlbums)
                    }

                    taskGroup.addTask {

                        let endPoint = UsersSavedItems.playlists(limit: self.fetchLimit)
                        let savedPlaylists = try await self.executeRequest(
                            for: endPoint,
                            of: SavedPlaylistsResponse.self
                        )
                        await self.delegate?.didLoadData(for: .playlists, with: savedPlaylists)
                    }

                    taskGroup.addTask {

                        let endPoint = UsersSavedItems.following(limit: self.fetchLimit, type: .artist)
                        let savedArtists = try await self.executeRequest(
                            for: endPoint,
                            of: SavedArtistsResponse.self
                        )
                        await self.delegate?.didLoadData(for: .artists, with: savedArtists)
                    }

                    try await taskGroup.waitForAll()
                    
                    await self.delegate?.didFinishLoading()
                }
            } catch {
                await delegate?.didFailLoading(with: error)
            }
        }
    }
}

// MARK: - Service Resolver
extension LibraryDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
