//
//  PlaylistResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-11.
//

import Foundation

struct PlaylistResponse: Codable {

    let collaborative: Bool
    let description: String
    let followers: Followers?
    let href: URL?
    let id: String
    let images: [Images]?
    let name: String
    let owner: Owner
    let tracks: Tracks
    let type: ItemType
    let uri: String

    struct Tracks: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [PlaylistTrackItem]

    }

    struct Track: Codable {

        let album: Album
        let artists: [Artist]
        let availableMarkets: [String]
        let discNumber: Int
        let durationMs: Int
        let explicit: Bool
        let externalIds: ExternalIds
        let externalUrls: [String: String]
        let href: String
        let id: String
        let isPlayable: Bool?
        let linkedFrom: [String: String]?
        let restrictions: Restrictions?
        let name: String
        let popularity: Int
        let previewUrl: String?
        let trackNumber: Int
        let type: ItemType
        let uri: String
        let isLocal: Bool
    }
}
