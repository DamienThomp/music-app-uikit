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
    case saveAlbums(ids: [String])
    case removeAlbums(ids: [String])

    var path: String {

        switch self {
        case .albums, .saveAlbums, .removeAlbums:
            return "/me/albums"
        case .playlists:
            return "/me/playlists"
        case .following:
            return "/me/following"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .saveAlbums:
            .put
        case .removeAlbums:
            .delete
        case .albums, .playlists, .following:
            .get
        }
    }

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
        case .saveAlbums, .removeAlbums:
            return nil
        }
    }

    var parameters: [String: Any?]? {

        switch self {
        case .albums, .following, .playlists:
            return nil
        case .saveAlbums(let ids), .removeAlbums(let ids):
            return ["ids": ids ]
        }
    }
}
