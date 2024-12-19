//
//  ArtistDetailsDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import Foundation

protocol ArtistDetailsDataSourceDelegate: AnyObject {

    //@MainActor func didLoadData(for sectionType: ItemDetailsSectionType, with data: Codable, of type: ItemType)
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

// MARK: - Service Resolver
extension ArtistDetailsDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
