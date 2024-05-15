//
//  PlaylistsEndpoint.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-08.
//

import Foundation

enum PlaylistsEndpoint: EndpointProtocol {

    case playlist(id: String)

    var httpMethod: HTTPMethod { .get }

    var path: String {
        switch self {
            
        case .playlist(id: let id):
            "/playlists/\(id)"
        }
    }
}
