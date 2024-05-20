//
//  NewReleases.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-03-29.
//

import Foundation

struct NewReleases: Codable {

    let albums: Albums

    struct Albums: Codable {

        let href: URL
        let limit: Int
        let next: URL
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [Album]
    }
}
