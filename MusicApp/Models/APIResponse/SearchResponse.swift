//
//  SearchResponse.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-13.
//

import Foundation

struct SearchResponse: Codable {

    let tracks: Tracks
    let artists: Artists
    let albums: Albums

    struct Tracks: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [Track]
    }

    struct Artists: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [Artist]

    }

    struct Albums: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [Album]
    }
}
