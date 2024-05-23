//
//  ItemDetailsDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-22.
//

import Foundation

enum ItemDetailsSectionType: Hashable {

    case main
    case related
}

struct ItemDetailsSection: Hashable {

    let sectionType: ItemDetailsSectionType
    let sectionHeader: ItemDetailSectionHeader?
    let items: [BrowseItem]
}

struct ItemDetailSectionHeader: Hashable {

    let id: String
    let title: String
    let subtitle: String?
    let image: URL?
    let type: ItemType?

    init(
        id: String,
        title: String,
        subtitle: String? = nil,
        image: URL? = nil,
        type: ItemType? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.type = type
    }
}



protocol ItemDetailsDataSourceDelegate: AnyObject {

    @MainActor func didLoadData(for sectionType: ItemDetailsSectionType, with data: Codable, of type: ItemType)
    @MainActor func didFinishLoading()
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
}

//MARK: - Data Fetching
extension ItemDetailsDataSource {

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
extension ItemDetailsDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
