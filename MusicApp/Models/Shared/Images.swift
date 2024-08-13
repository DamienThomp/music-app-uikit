//
//  Images.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-29.
//

import Foundation

struct Images: Codable, Hashable {

    let url: URL
    let height: Int?
    let width: Int?
}

protocol ImageUrls {

    var imageUrl: URL? { get }
    var smallImageUrl: URL? { get }
    var imageUrlWithDimensions: Images? { get }
}

extension Array: ImageUrls where Element == Images {

    var imageUrlWithDimensions: Images? { self.first }

    var imageUrl: URL? { self.first?.url }

    var smallImageUrl: URL? {

        if let image = self.first(where: {

            guard let width = $0.width else { return false }

            return width < 160
        }) {
            return image.url
        }

        return self.imageUrl
    }
}
