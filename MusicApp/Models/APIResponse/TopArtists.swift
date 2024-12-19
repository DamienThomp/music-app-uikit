//
//  TopArtists.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-06.
//

import Foundation

struct TopArtists: Codable {

    let href: URL?
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
    let items: [Artist]
}

struct ArtistItem: Codable {

    let id: String
    let genres: [String]
    let name: String
    let images: [Images]?
    let type: ItemType
}
