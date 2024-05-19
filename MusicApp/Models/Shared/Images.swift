//
//  Images.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-03-29.
//

import Foundation

struct Images: Codable {

    let url: URL
    let height: Int?
    let width: Int?
}

protocol ImageUrls {

    var imageUrl: URL? { get }
    var largeImageUrl: URL? { get }
}

extension Array: ImageUrls where Element == Images {

    var imageUrl: URL? { self.first?.url }

    var largeImageUrl: URL? {

        let largeImage = self.filter {

            guard let height = $0.height else { return false }

            return height >= 600
        }

        return !largeImage.isEmpty ? largeImage[0].url : self.imageUrl
    }

    var imageUrlWithDimensions: Images? {
        return self.first
    }

}
