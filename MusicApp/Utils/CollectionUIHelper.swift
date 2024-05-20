//
//  CollectionUIHelper.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-07.
//

import UIKit

enum SectionHeaderType {
    case title
    case banner
}

struct CollectionUIHelper {

    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {

        let width = view.bounds.width
        let padding: CGFloat = 4
        let minItemSpacing: CGFloat = 6
        let availableWidth = width - (padding * 2) - (minItemSpacing * 2)
        let cellWidth = availableWidth / 2

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        return flowLayout
    }

    static func createFeaturedHorizontalSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))

        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 0, trailing: 4)

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.95),
                heightDimension: .fractionalWidth(1.05)
            ),
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: hGroup)
        section.orthogonalScrollingBehavior = .groupPaging

        let layoutSectionHeader = createSectionHeader(for: .title)
        section.boundarySupplementaryItems = [layoutSectionHeader]

        return section
    }

    static func createTwoRowHorizontalSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(250)
        ))

        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let vGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.9)
            ),
            repeatingSubitem: item,
            count: 2
        )

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.48),
                heightDimension: .estimated(520)
            ),
            repeatingSubitem: vGroup,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: hGroup)
        section.orthogonalScrollingBehavior = .groupPaging

        let layoutSectionHeader = createSectionHeader(for: .title)
        section.boundarySupplementaryItems = [layoutSectionHeader]

        return section
    }

    static func createMultiRowHorizontalListSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        ))

        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 4)

        let vGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)
            ),
            repeatingSubitem: item,
            count: 4
        )

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.94),
                heightDimension: .estimated(240)
            ),
            repeatingSubitem: vGroup,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: hGroup)
        section.orthogonalScrollingBehavior = .groupPaging

        let layoutSectionHeader = createSectionHeader(for: .title)
        section.boundarySupplementaryItems = [layoutSectionHeader]

        return section
    }

    static func createSectionHeader(for sectionHeaderType: SectionHeaderType) -> NSCollectionLayoutBoundarySupplementaryItem {

        switch sectionHeaderType {
        case .title:
            let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(150))
            let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            return layoutSectionHeader
        case .banner:
            let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(150))
            let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            return layoutSectionHeader
        }
    }
}
