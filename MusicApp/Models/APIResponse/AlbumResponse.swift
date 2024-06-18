//
//  AlbumResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-10.
//

import Foundation

struct AlbumResponse: Codable {
    
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: [String: String]
    let href: String
    let id: String
    let images: [Images]?
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let restrictions: Restrictions?
    let type: ItemType
    let uri: String
    let artists: [Artist]
    let tracks: Track
    let copyright: [Copyright]?
    let genres: [String]
    let label: String
    let popularity: Int?

    struct Track: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [AlbumTrackItem]
    }

    struct AlbumTrackItem: Codable {

        let artists: [Artist]
        let availableMarkets: [String]
        let discNumber: Int
        let durationMs: Int
        let explicit: Bool
        let externalUrls: [String: String]
        let href: String
        let id: String
        let isPlayable: Bool?
        let restrictions: [String: String]?
        let name: String
        let previewUrl: String?
        let trackNumber: Int
        let type: String
        let uri: String
        let isLocal: Bool
    }

    struct Copyright: Codable {

        let text: String
        let type: String
    }
}
