//
//  BrowseDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import Foundation

enum BrowseSections: Hashable, CaseIterable {

    case newReleases
    case featured
    case recommended

    var title: String {

        switch self {
        case .newReleases:
            return "New Releases"
        case .featured:
            return "Featured Playlists"
        case .recommended:
            return "Recommended Tracks"
        }
    }
}

protocol BrowseDataSourceDelegate: AnyObject {

    @MainActor func didLoadData(for section: BrowseSections, with data: Codable)
    @MainActor func didFinishLoading()
    @MainActor func didFailLoading(with error: Error)
}

class BrowseDataSource {

    private let decoder: JSONDecoder = {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }()

    private var authManager: AuthManager?
    private var networkManager: NetworkManager?

    weak var delegate: BrowseDataSourceDelegate?
}

// MARK: - Data Fetching
extension BrowseDataSource {

    private func getRandomSeeds(seeds: [String]) -> String {

        var genreSeeds = Set<String>()

        while genreSeeds.count < 5 {

            if let randomElement = seeds.randomElement() {
                genreSeeds.insert(randomElement)
            }
        }

        return genreSeeds.joined(separator: ",")
    }

    private func getRandomArtistSeeds(from albumItems: [SavedAlbumResponse.SavedAlbumItem]) -> String {

        let seeds = albumItems.map {
            if let genre = $0.album.artists.randomElement()?.id {
                return genre
            } else {
                return ""
            }
        }

        return seeds.isEmpty ? "" : seeds.joined(separator: ",")
    }

    private func fetchRecommendationSeeds() async throws -> (String?, String?) {

        var artistSeeds: String?
        var genreSeeds: String?

        let savedAlbumsData = try await self.executeRequest(
            for: UsersSavedItems.albums(
                limit: 5
            )
        )

        let albums = try decoder.decode(SavedAlbumResponse.self, from: savedAlbumsData)

        if !albums.items.isEmpty {
            artistSeeds = getRandomArtistSeeds(from: albums.items)
        } else {
            let genreData = try await self.executeRequest(for: RecommendationsEndpoint.genre)
            let genres = try decoder.decode(Genres.self, from: genreData)
            genreSeeds = getRandomSeeds(seeds: genres.genres)
        }

        return (artistSeeds, genreSeeds)
    }

    private func fetchNewReleases() async throws -> NewReleases? {

        let limit = 21
        let data = try await self.executeRequest(
            for: BrowseEndpoint.albums(
                limit
            )
        )

        return try decoder.decode(NewReleases.self, from: data)
    }

    private func fetchFeaturedPlaylists() async throws -> SavedPlaylistsResponse? {

        let endPoint = UsersSavedItems.playlists(limit: 25)
        let data = try await executeRequest(for: endPoint)

        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        print(json)

        return try decoder.decode(SavedPlaylistsResponse.self, from: data)
    }

    private func fetchTopTracks() async throws -> TrackResponse {
        let endpoint = UsersTopItemsEnpoint.tracks(limit: 25, offset: 0)
        let data = try await executeRequest(for: endpoint)

        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        print(json)

        return try decoder.decode(TrackResponse.self, from: data)

    }

    private func executeRequest(for endPoint: EndpointProtocol) async throws -> Data {

        guard let networkManager else {
            throw ServiceResolverErrors.failedToResolveService
        }

        return try await networkManager.request(for: endPoint)
    }

    func fetchDisplayData() {

        Task {
            do {

                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                try await withThrowingTaskGroup(of: Void.self) { taskGroup in

                    taskGroup.addTask {
                        let newReleases = try await self.fetchNewReleases()
                        await self.delegate?.didLoadData(for: .newReleases, with: newReleases)
                    }

                    taskGroup.addTask {
                        let featuredPlaylists = try await self.fetchFeaturedPlaylists()
                        await self.delegate?.didLoadData(for: .featured, with: featuredPlaylists)
                    }

                    taskGroup.addTask {
                      //  let recommendations = try await self.fetchTopTracks()
                       // await self.delegate?.didLoadData(for: .recommended, with: recommendations)
                    }

                    try await taskGroup.waitForAll()
                    await self.delegate?.didFinishLoading()
                }
            } catch {
                print(error)
                await delegate?.didFailLoading(with: error)
            }
        }
    }
}

// MARK: - Service Resolver
extension BrowseDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
