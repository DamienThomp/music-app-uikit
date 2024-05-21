//
//  UIImageView+LoadImage.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-28.
//

import UIKit

fileprivate let cache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImage(from urlString: String) async {

        guard let url = URL(string: urlString) else { return }

        let cachKey = NSString(string: urlString)

        if let image = cache.object(forKey: cachKey) {
            await self.assignImage(with: image)
            return
        }

        do {

            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else { return }

            cache.setObject(image, forKey: cachKey)

            await self.assignImage(with: image)

        } catch {

            #if DEBUG
            print("error loading image from url: \(error)")
            #endif
        }
    }

    @MainActor
    private func assignImage(with image: UIImage) async {
        self.image = image.preparingForDisplay()
    }
}
