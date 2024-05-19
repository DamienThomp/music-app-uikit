//
//  SavedAlbum.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-06.
//

import Foundation

struct SavedAlbumResponse: Codable {

    let href: URL?
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
    let items: [SavedAlbumItem]

    struct SavedAlbumItem: Codable {

        let album: Album
    }

}
