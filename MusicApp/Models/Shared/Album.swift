//
//  Album.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-03-31.
//

import Foundation

struct Album: Codable {

    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: [String : String]
    let href: String
    let id: String
    let images: [Images]?
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let restrictions: Restrictions?
    let type: ItemType
    let uri: String
    let artists: [Artist]
    let genres: [String]?
    let tracks: Tracks?

    var imageUrl: URL? {

        guard let images = self.images,
              images.count > 0
        else { return nil }

        return images[0].url
    }

    var largeImage: URL? {

        guard let images = self.images, 
              images.count > 0
        else { return nil }

        let largeImage = images.filter {

            guard let height = $0.height else { return false }

            return height >= 600
        }

        return !largeImage.isEmpty ? largeImage[0].url : images[0].url
    }

}
