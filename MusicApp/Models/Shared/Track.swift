//
//  Track.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-08.
//

import Foundation

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
