//
//  UIImageView+LoadImage.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-28.
//

import UIKit

extension UIImageView {

    func loadImage(from urlString: String) async {

        guard let url = URL(string: urlString) else { return }

        let cacheKey = NSString(string: urlString)

        if let image = ImageCache.getImage(for: cacheKey) {
            await self.assignImage(with: image)
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else { return }

            ImageCache.setImage(with: image, for: cacheKey)

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
