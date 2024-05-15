//
//  BrowseEndpoint.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-29.
//

import Foundation

fileprivate let defaultLimit: Int = 50

enum BrowseEndpoint: EndpointProtocol {

    case albums(_ limit: Int = defaultLimit, _ offset: Int = 0)
    case featuredPlaylists(_ limit: Int = defaultLimit, _ offset: Int = 0)
    case categories(limit: Int = defaultLimit, offset: Int = 0)

    var httpMethod: HTTPMethod {
        return .get
    }

    var path: String {

        switch self {
        case .albums:
            "/browse/new-releases"
        case .featuredPlaylists:
            "/browse/featured-playlists"
        case .categories:
            "/browse/categories"
        }
    }

    var queryItems: [URLQueryItem]? {

        switch self {
        case .albums(let limit, let offset),
             .featuredPlaylists(let limit, let offset),
             .categories(let limit, let offset):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        }
    }
}
