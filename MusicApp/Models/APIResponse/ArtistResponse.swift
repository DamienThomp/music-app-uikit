//
//  ArtistAlbumsResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-13.
//

import Foundation

struct ArtistResponse: Codable {

    struct Albums: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [Album]
    }
    
    struct TopTracks: Codable {

        let tracks: [Track]
    }

    struct RelatedArtist: Codable {

        let artist: [Artist]
    }
}
