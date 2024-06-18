//
//  ImageCache.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-23.
//

import UIKit

class ImageCache {

    static let cache = NSCache<NSString, UIImage>()

    private init() {
       Self.cache.countLimit = 50
    }

    static func getImage(for key: NSString) -> UIImage? {
        return cache.object(forKey: key)
    }

    static func setImage(with image: UIImage, for key: NSString) {
        cache.setObject(image, forKey: key)
    }
}
