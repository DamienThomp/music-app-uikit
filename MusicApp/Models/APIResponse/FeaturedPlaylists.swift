//
//  FeaturedPlaylists.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-29.
//

import Foundation

struct FeaturedPlaylists: Codable {

    let message: String
    let playlists: Playlist

    struct Playlist: Codable {

        let href: URL
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [PlaylistItems]
    }
}

struct PlaylistItems: Codable, Hashable {

    let description: String
    let id: String
    let images: [Images]
    let name: String
    let owner: Owner
    let type: ItemType

    static func == (lhs: PlaylistItems, rhs: PlaylistItems) -> Bool {
        return lhs.images == rhs.images
    }
}
