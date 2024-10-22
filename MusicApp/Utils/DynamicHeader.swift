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
                    let offset = contentOffsetY
                    let dif = abs(contentOffsetY - collectionView.frame.height) / 1000
                    attributes.alpha = CGFloat(dif)
                }
            }
        })

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
