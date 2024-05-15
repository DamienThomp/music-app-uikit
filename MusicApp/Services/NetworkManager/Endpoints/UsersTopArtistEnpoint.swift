//
//  UsersTopArtistEnpoint.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-06.
//

import Foundation

enum UsersTopItemsEnpoint: EndpointProtocol {

    case artists(limit: Int = 5, offset: Int = 0)
    case tracks(limit: Int = 5, offset: Int = 0)

    var path: String {

        switch self {
        case .artists:
            "/me/top/artists"
        case .tracks:
            "/me/top/tracks"
        }
    }

    var httpMethod: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {

        switch self {
        case .artists(let limit, let offset), .tracks(let limit, let offset):
            return [
                URLQueryItem(name: "time_range", value: "long_term"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        }
    }
}
