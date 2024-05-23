//
//  ItemViewCell.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-23.
//

import UIKit

class ItemViewCell: UICollectionViewCell {

    let coverImage = AsyncImageView(frame: .zero)
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    override func prepareForReuse() {
        super.prepareForReuse()

        coverImage.cancelImageLoad()
        titleLabel.text = nil
        subtitleLabel.text = nil
        coverImage.image = nil
    }

    func configure(with item: CellItemProtocol) {

        titleLabel.text = item.title
        subtitleLabel.text = item.subTitle
        coverImage.executeLoad(from: item.image)
    }
}
