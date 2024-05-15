//
//  ArtistEndpoint.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-13.
//

import Foundation

enum IncludeGroup: String {

    case single = "single"
    case album = "album"
    case compilation = "compilation"
    case appearsOn = "appears_on"
}

enum ArtistEndpoint: EndpointProtocol {

    case artist(id: String)
    case albums(id: String, includeGroup: [IncludeGroup], limit: Int = 20, offset: Int = 0)
    case topTracks(id: String)
    case relatedArtists(id: String)

    var path: String {

        switch self {
        case .artist(let id):
            return "/artists/\(id)"
        case .albums(let id, let includeGroup, let limit, let offset):
            return "/artists/\(id)/albums"
        case .topTracks(let id):
            return "/artists/\(id)/top-tracks"
        case .relatedArtists(let id):
            return "/artists/\(id)/related-artists"
        }
    }

    var httpMethod: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {
        
        switch self {
        case .artist, .topTracks, .relatedArtists:
            return nil
        case .albums(let id, let includeGroup, let limit, let offset):
            return [
                URLQueryItem(
                    name: "include_group",
                    value: includeGroup.map { $0.rawValue }.joined(separator: ",")
                ),
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
