//
//  AlbumsResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import Foundation

struct AlbumsResponse: Codable {

    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [AlbumItem]?

    struct AlbumItem: Codable {
        
        let album: AlbumResponse
    }
}
