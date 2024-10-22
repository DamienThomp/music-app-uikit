//
//  DynamicHeader.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-10-21.
//

import UIKit

class DynamicHeader: UICollectionViewCompositionalLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let layoutAttributes = super.layoutAttributesForElements(in: rect)

        layoutAttributes?.forEach({ (attributes) in

            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {

                guard let collectionView = collectionView else { return }

                let contentOffsetY = collectionView.contentOffset.y

                if contentOffsetY <= 0 {
                    attributes.alpha = 1
                } else {
                    let height = attributes.frame.size.height
                    let position = contentOffsetY
                    let percentage = position / height
                    attributes.alpha = CGFloat(1.0 - percentage)
                }
            }
        })

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
