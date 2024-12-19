//
//  ArtistDetailsViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

class ArtistDetailsViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<ArtistDetailSection, BrowseItem>

    weak var coordinator: ArtistDetailsCoordinator?
    var viewModel: ArtistDetailsViewModel?

    var artistId: String?
    var dataSource: DataSource?
    
    private var collection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configure()

        showLoadingState()

        viewModel?.createInitialSnapshot()
        
        viewModel?.fetchData(for: artistId)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collection?.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: view.safeAreaInsets.bottom,
            right: 0
        )
    }

    func configure() {
        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSource()
        configureDataSourceSupplement()
    }
}

// MARK: - Collection View Configuration
extension ArtistDetailsViewController {

    private func configureCollectionView() {

        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSectionLayout(for: sectionIndex)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        layout.configuration = config

        collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collection)
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {

        guard let snapshot = self.viewModel?.snapshot else { return nil }

        switch snapshot.sectionIdentifiers[sectionIndex] {
        case .albums:
            return CollectionUIHelper.createTwoRowHorizontalSection()
        case .tracks:
            return CollectionUIHelper.createMultiRowHorizontalListSection()
        }
    }

    private func registerCells() {
        
        collection.register(
            AlbumTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.reuseIdentifier
        )

        collection.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.reuseIdentifier
        )

        collection.register(
            CoverCollectionViewCell.self,
            forCellWithReuseIdentifier: CoverCollectionViewCell.reuseIdentifier
        )

        collection.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )

        collection.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")
    }
}

extension ArtistDetailsViewController {

    private func configureDataSource() {

        dataSource = DataSource(collectionView: collection, cellProvider: { [weak self] _, indexPath, item in

            guard let snapshot = self?.viewModel?.snapshot else { return UICollectionViewCell() }

            switch snapshot.sectionIdentifiers[indexPath.section] {
            case .albums:
                return self?.collection.configureCell(
                    of: CoverCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            case .tracks:
                return self?.collection.configureCell(
                    of: AlbumTrackCollectionViewCell.self,
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

                return UICollectionViewCell()
            }

            guard let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {

                return UICollectionViewCell()
            }

            sectionHeader.title.text = section.title

            return sectionHeader
        }
    }
}

extension ArtistDetailsViewController: UICollectionViewDelegate {

}

extension ArtistDetailsViewController: ArtistDetailViewModelDelegate {
    
    func reloadData() {
        
        guard let snapshot = viewModel?.snapshot,
              let header = viewModel?.header
        else { return }

        clearContentUnavailableState()

        updateHeader(with: header)

        dataSource?.apply(snapshot)
    }
    
    func didFailLoading(with error: Error) {
        showErrorState(for: error)
    }
    
    func didUpdateSavedStatus() {
        // todo
    }
    
    func didFailToSaveItem() {
        // todo
    }
}
