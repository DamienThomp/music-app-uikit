//
//  AsyncImageView.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-20.
//

import UIKit

class AsyncImageView: UIImageView {

    private var task: Task<(), Never>?

    func executeLoad(from url: URL?) {

        guard let url = url?.absoluteString else {
            print("can't get url")
            return
        }

        task = Task {
            await self.loadImage(from: url)
        }
    }

    func cancelImageLoad() {
        task?.cancel()
    }

}
