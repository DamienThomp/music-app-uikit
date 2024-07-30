//
//  Playlist.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-02-15.
//

import Foundation

struct Playlist: Codable {

    let collaborative: Bool
    let description: String
    let followers: Followers?
    let href: URL?
    let id: String
    let images: [Images]?
    let name: String
    let owner: Owner
    let tracks: Tracks
}

struct Tracks: Codable {

    let href: URL?
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
    let items: [PlaylistTrackItem]
}

struct PlaylistTrackItem: Codable {

    let addedAt: String?
    let addedBy: AddedByItem?
    let track: Track?
}

struct AddedByItem: Codable {

    let externalUrls: [String: String]?
    let followers: Followers?
    let href: URL?
    let id: String
    let type: String
    let uri: String
}
