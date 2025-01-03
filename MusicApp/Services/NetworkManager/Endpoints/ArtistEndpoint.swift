//
//  ArtistEndpoint.swift
//  MusicApp
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
    case contains(ids: [String])

    var path: String {

        switch self {
        case .artist(let id):
            return "/artists/\(id)"
        case .albums(let id, _, _, _):
            return "/artists/\(id)/albums"
        case .topTracks(let id):
            return "/artists/\(id)/top-tracks"
        case .relatedArtists(let id):
            return "/artists/\(id)/related-artists"
        case .contains:
            return "/me/following/contains"
        }
    }

    var httpMethod: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {

        switch self {
        case .artist, .relatedArtists, .topTracks:
            return nil
        case .albums(_, let includeGroup, let limit, let offset):
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
        case .contains(let ids):
            return [
                URLQueryItem(
                    name: "ids",
                    value: ids.map { $0 }.joined(separator: ",")
                ),
                URLQueryItem(
                    name: "type",
                    value: "artist"
                )
            ]
        }
    }
}
