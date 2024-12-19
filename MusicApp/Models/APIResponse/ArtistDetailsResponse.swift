//
//  ArtistDetailsResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import Foundation

struct ArtistDetailsResponse: Codable {

    let id: String
    let name: String
    let images: [Images]
}
