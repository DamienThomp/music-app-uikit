//
//  UsersSavedAlbums.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-06.
//

import Foundation

enum FollowingType: String {
    case artist
}

enum UsersSavedItems: EndpointProtocol {

    case albums(limit: Int = 5, offset: Int = 0)
    case playlists(limit: Int = 5, offset: Int = 0)
    case following(limit: Int = 5, type: FollowingType)

    var path: String {

        switch self {
        case .albums:
            return "/me/albums"
        case .playlists:
            return "/me/playlists"
        case .following:
            return "/me/following"
        }
    }

    var httpMethod: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {

        switch self {
        case .albums(let limit, let offset),
             .playlists(let limit, let offset):
            return [
                URLQueryItem(
                    name: "limit",
                    value: "\(limit)"
                ),
                URLQueryItem(
                    name: "offset",
                    value: "\(offset)"
                )
            ]
        case .following(let limit, let type):
            return [
                URLQueryItem(
                    name: "limit",
                    value: "\(limit)"
                ),
                URLQueryItem(
                    name: "type",
                    value: type.rawValue
                )
            ]
        }
    }
}
