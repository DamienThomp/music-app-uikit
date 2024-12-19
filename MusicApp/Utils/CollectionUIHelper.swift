//
//  CollectionUIHelper.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-07.
//

import UIKit

enum SectionHeaderType {

    case title
    case banner
}

struct CollectionUIHelper {

    private static func getLayoutSize(
        _ width: NSCollectionLayoutDimension,
        _ height: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutSize {
        .init(widthDimension: width, heightDimension: height)
    }

    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {

        let width = view.bounds.width
        let padding: CGFloat = 4
        let minItemSpacing: CGFloat = 6
        let availableWidth = width - (padding * 2) - (minItemSpacing * 2)
        let cellWidth = availableWidth / 2

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = .init(width: cellWidth, height: cellWidth)

        flowLayout.headerReferenceSize = .init(width: width, height: 50)

        return flowLayout
    }

    static func createSingleItemBannerLayout() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(
            layoutSize: getLayoutSize(
                .fractionalWidth(1),
                .fractionalHeight(1)
            )
        )

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: getLayoutSize(
               .fractionalWidth(1),
               .fractionalWidth(1)
            ),
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: hGroup)

        let layoutSectionHeader = createSectionHeader(for: .banner)
        section.boundarySupplementaryItems = [layoutSectionHeader]

        return section
    }

    static func createFeaturedHorizontalSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(
            layoutSize: getLayoutSize(
                .fractionalWidth(1),
                .fractionalHeight(1)
            )
        )

        item.contentInsets = .init(top: 4, leading: 8, bottom: 0, trailing: 4)

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: getLayoutSize(
               .fractionalWidth(0.95),
               .fractionalWidth(1.05)
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

        let item = NSCollectionLayoutItem(
            layoutSize: getLayoutSize(
                .fractionalWidth(1),
                .absolute(250)
            )
        )

        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)

        let vGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: getLayoutSize(
               .fractionalWidth(1),
               .fractionalHeight(0.9)
            ),
            repeatingSubitem: item,
            count: 2
        )

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: getLayoutSize(
                .fractionalWidth(0.48),
                .estimated(520)
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

        let item = NSCollectionLayoutItem(
            layoutSize: getLayoutSize(
                .fractionalWidth(1.0),
                .fractionalHeight(1.0)
            )
        )

        item.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 4)

        let vGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: getLayoutSize(
                .fractionalWidth(1.0),
                .estimated(60)
            ),
            repeatingSubitem: item,
            count: 4
        )

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: getLayoutSize(
               .fractionalWidth(0.94),
               .estimated(240)
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

    static func createTrackListLayout() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(
            layoutSize: getLayoutSize(
                .fractionalWidth(1.0),
                .fractionalHeight(1.0)
            )
        )

        item.contentInsets = .init(top: 2, leading: 0, bottom: 2, trailing: 0)

        let vGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: getLayoutSize(
                .fractionalWidth(1.0),
                .estimated(60)
            ),
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: vGroup)

        let layoutSectionHeader = createSectionHeader(for: .banner)
        section.boundarySupplementaryItems = [layoutSectionHeader]
        
        return section
    }

    static func createItemViewLayout() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(
            layoutSize: getLayoutSize(
                .fractionalWidth(1),
                .fractionalHeight(1)
            )
        )

        item.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 4)

        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: getLayoutSize(
                .absolute(190),
                .absolute(300)
            ),
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: hGroup)
        section.orthogonalScrollingBehavior = .continuous

        let layoutSectionHeader = createSectionHeader(for: .title)
        section.boundarySupplementaryItems = [layoutSectionHeader]

        let decorator = NSCollectionLayoutDecorationItem.background(elementKind: SectionDecorator.reuseIdentifier)
        section.decorationItems = [decorator]

        section.contentInsets = .init(top: 8, leading: 0, bottom: 40, trailing: 0)

        return section
    }

    static func createSectionHeader(for sectionHeaderType: SectionHeaderType) -> NSCollectionLayoutBoundarySupplementaryItem {

        switch sectionHeaderType {
        case .title:

            let layoutSectionHeaderSize = getLayoutSize(
                .fractionalWidth(0.93),
                .estimated(150)
            )
            let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSectionHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )

            return layoutSectionHeader
        case .banner:

            let layoutSectionHeaderSize = getLayoutSize(
                .fractionalWidth(1),
                .fractionalHeight(0.65)
            )
            let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSectionHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            return layoutSectionHeader
        }
    }
}
