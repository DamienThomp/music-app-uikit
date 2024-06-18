//
//  Album.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-31.
//

import Foundation

struct Album: Codable {

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
    let genres: [String]?
    let tracks: Tracks?
}
