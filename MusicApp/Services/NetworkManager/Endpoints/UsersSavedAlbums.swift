//
//  UsersSavedAlbums.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-06.
//

import Foundation

enum UsersSavedItems: EndpointProtocol {

    case albums(limit: Int = 5, offset: Int = 0)

    var path: String {

        switch self {
        case .albums:
            return "/me/albums"
        }
    }

    var httpMethod: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {

        switch self {
        case .albums(let limit, let offset):
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
        }
    }
}
