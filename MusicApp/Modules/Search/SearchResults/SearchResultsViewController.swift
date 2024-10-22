//
//  SearchResultsViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-10-19.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {

    @MainActor func didSelectItem(item: BrowseItem)
}

class SearchResultsViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<SearchResultSection, BrowseItem>

    private var dataSource: DataSource?
    private var collectionView: UICollectionView!
    private var snapshot: NSDiffableDataSourceSnapshot<SearchResultSection, BrowseItem>?

    weak var delegate: SearchResultsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        showLoadingState()
        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
    }

    func updateSnapshot(with data: NSDiffableDataSourceSnapshot<SearchResultSection, BrowseItem>) {
        self.snapshot = data
        clearContentUnavailableState()
        dataSource?.apply(snapshot!)
    }

    private func configureCollectionView() {

        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSectionLayout(for: sectionIndex)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        layout.configuration = config

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground

        view.addSubview(collectionView)
    }

    private func registerCells() {

        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )

        collectionView.register(
            CoverCollectionViewCell.self,
            forCellWithReuseIdentifier: CoverCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            PlaylistTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaylistTrackCollectionViewCell.reuseIdentifier
        )
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {

        let sections = SearchResultSection.allCases

        switch sections[sectionIndex] {
        case .albums, .artists:
            return CollectionUIHelper.createTwoRowHorizontalSection()
        case .tracks:
            return CollectionUIHelper.createMultiRowHorizontalListSection()
        }
    }
}

// MARK: - Data Source
extension SearchResultsViewController {

    private func configureDataSource() {

        dataSource = DataSource(collectionView: collectionView, cellProvider: { _, indexPath, item in
            guard let snapshot = self.snapshot else { return nil }

            switch snapshot.sectionIdentifiers[indexPath.section] {

            case .albums, .artists:
                return self.collectionView.configureCell(
                    of: CoverCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            case .tracks:
                return self.collectionView.configureCell(
                    of: PlaylistTrackCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            }
        })
    }

    private func configureDataSourceSupplement() {

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in

            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath
            ) as? SectionHeader else {

                return nil
            }

            guard let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {

                return nil
            }

            if section.title.isEmpty { return nil }

            sectionHeader.title.text = section.title

            return sectionHeader
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchResultsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = self.dataSource?.itemIdentifier(for: indexPath),
              let type = item.type else { return }

        delegate?.didSelectItem(item: item)
    }
}
