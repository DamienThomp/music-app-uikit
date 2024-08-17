//
//  ItemDetailsDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-22.
//

import Foundation

protocol ItemDetailsDataSourceDelegate: AnyObject {

    @MainActor func didLoadData(for sectionType: ItemDetailsSectionType, with data: Codable, of type: ItemType)
    @MainActor func didFinishLoading()
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didUpdateSavedStatus()
    @MainActor func didFailToSaveItem()
}

class ItemDetailsDataSource {

    private let decoder: JSONDecoder = {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }()

    private var authManager: AuthManager?
    private var networkManager: NetworkManager?

    weak var delegate: ItemDetailsDataSourceDelegate?

    var isSavedAlbum: Bool = false
}

// MARK: - Data Fetching
extension ItemDetailsDataSource {

    func saveAlbum(with albumId: String) async throws {

        let endPoint = UsersSavedItems.saveAlbums(ids: [albumId])
        _ = try await executeRequest(for: endPoint)
    }

    func removeAlbum(with albumId: String) async throws {

        let endPoint = UsersSavedItems.removeAlbums(ids: [albumId])
        _ = try await executeRequest(for: endPoint)
    }

    func getIsSavedAlbumStatus(for albumId: String) async throws -> [Bool] {

        let endPoint = AlbumsEndpoint.contains(ids: [albumId])
        let responseData = try await executeRequest(for: endPoint)

        return try decoder.decode([Bool].self, from: responseData)
    }

    func getPlaylist(for id: String) async throws -> PlaylistResponse {

        let endpoint = PlaylistsEndpoint.playlist(id: id)
        let responseData = try await executeRequest(for: endpoint)

        return try decoder.decode(PlaylistResponse.self, from: responseData)
    }

    func getRelatedAlbums(for id: String) async throws -> ArtistResponse.Albums {

        let endpoint = ArtistEndpoint.albums(id: id, includeGroup: [.album, .single], limit: 10)
        let responseData = try await executeRequest(for: endpoint)
        return try decoder.decode(ArtistResponse.Albums.self, from: responseData)
    }

    func getAlbum(for id: String) async throws -> AlbumResponse {

        let endpoint = AlbumsEndpoint.album(id: id)
        let responseData = try await executeRequest(for: endpoint)
        return try decoder.decode(AlbumResponse.self, from: responseData)
    }

    func executeRequest(for endPoint: EndpointProtocol) async throws -> Data {

        guard let networkManager else {
            throw ServiceResolverErrors.failedToResolveService
        }

        return try await networkManager.request(for: endPoint)
    }

    func updateSavedAlbumStatus(with albumId: String) {

        Task { @MainActor in
            
            do {

                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                if isSavedAlbum {
                    try await removeAlbum(with: albumId)
                    isSavedAlbum = false
                } else {
                    try await saveAlbum(with: albumId)
                    isSavedAlbum = true
                }
                delegate?.didUpdateSavedStatus()
            } catch {
                delegate?.didFailToSaveItem()
            }
        }
    }

    func fetchDispayData(with id: String, for type: ItemType) {

        Task {
            do {
                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                try await withThrowingTaskGroup(of: Void.self) { taskGroup in

                    if type == .playlist {

                        taskGroup.addTask {
                            let playlist = try await self.getPlaylist(for: id)
                            await self.delegate?.didLoadData(for: .main, with: playlist, of: .playlist)
                        }
                    }

                    if type == .album {
                        
                        taskGroup.addTask {

                            let album = try await self.getAlbum(for: id)
                            await self.delegate?.didLoadData(for: .main, with: album, of: .album)

                            guard let artistId = album.artists.first?.id else { return }

                            let related = try await self.getRelatedAlbums(for: artistId)
                            await self.delegate?.didLoadData(for: .related, with: related, of: .album)
                        }

                        taskGroup.addTask {

                            let response = try await self.getIsSavedAlbumStatus(for: id)

                            if let responseValue = response.first {
                                self.isSavedAlbum = responseValue
                            }
                        }
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
extension ItemDetailsDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
