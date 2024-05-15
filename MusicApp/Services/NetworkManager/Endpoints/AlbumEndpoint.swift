//
//  AlbumEndpoint.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-08.
//

import Foundation

enum AlbumsEndpoint: EndpointProtocol {

    case album(id: String)
    case albums(ids: [String])

    var httpMethod: HTTPMethod { .get }

    var path: String {

        switch self {
        case .album(let id):
            "/albums/\(id)"
        case .albums(let ids):
            "/albums/\(ids.joined(separator: " "))"
        }
    }
}
