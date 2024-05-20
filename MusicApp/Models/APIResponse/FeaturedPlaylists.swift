//
//  FeaturedPlaylists.swift
//  SpotifyCloneUIkit
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

struct PlaylistItems: Codable {

    let collaborative: Bool
    let description: String
    let externalUrls: [String : String]
    let href: String
    let id: String
    let images: [Images]?
    let name: String
    let owner: Owner
    let isPublic: Bool
    let snapshotId: String
    let tracks: Tracks
    let type: ItemType
    let uri: String

    struct Tracks: Codable {

        let href: String
        let total: Int
    }

    enum CodingKeys: String, CodingKey {

        case collaborative, description, externalUrls, href, id, images, name, owner, snapshotId, tracks, type, uri
        case isPublic = "public"
    }
}
