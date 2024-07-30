//
//  ArtistsResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import Foundation

struct SavedArtistsResponse: Codable {

    let artists: SavedArtists

    struct SavedArtists: Codable {

        let href: String?
        let limit: Int
        let total: Int
        let items: [Artist]
    }
}
