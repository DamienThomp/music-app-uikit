//
//  Images.swift
//  MusicApp
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
    var imageUrlWithDimensions: Images? { get }
}

extension Array: ImageUrls where Element == Images {

    var imageUrl: URL? { self.first?.url }

    var imageUrlWithDimensions: Images? {
        return self.first
    }

}
