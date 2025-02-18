//
//  LibraryViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import UIKit

class LibraryViewController: UIViewController {

    weak var coordinator: LibraryCoordinator?
    var viewModel: LibraryViewModel?

    typealias DataSource = UICollectionViewDiffableDataSource<LibrarySections, BrowseItem>

    private var collection: UICollectionView!

    private var dataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configure()
        viewModel?.createInitialSnapshot()
        showLoadingState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.fetchData()

        setNeedsUpdateContentUnavailableConfiguration()
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

    private func configure() {
        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
    }

    private func retryFetch() {

        showLoadingState()
        viewModel?.fetchData()
        setNeedsUpdateContentUnavailableConfiguration()
    }
}

// MARK: - Collection View Configuration
extension LibraryViewController {

    private func configureCollectionView() {

        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSectionLayout(for: sectionIndex)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 60
        layout.configuration = config

        collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .systemBackground

        view.addSubview(collection)
    }

    private func registerCells() {

        collection.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )

        collection.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "empty"
        )

        collection.register(
            CoverCollectionViewCell.self,
            forCellWithReuseIdentifier: CoverCollectionViewCell.reuseIdentifier
        )
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {

        guard let snapshot = self.viewModel?.snapshot else { return nil }

        switch snapshot.sectionIdentifiers[sectionIndex] {
        case .albums, .playlists, .artists:
            return CollectionUIHelper.createTwoRowHorizontalSection()
        }
    }
}

// MARK: - Data Source Configuration
extension LibraryViewController {

    private func configureDataSource() {

        dataSource = DataSource(collectionView: collection, cellProvider: { [weak self] _, indexPath, item in

            guard let snapshot = self?.viewModel?.snapshot else { return UICollectionViewCell() }

            switch snapshot.sectionIdentifiers[indexPath.section] {
            case .albums, .playlists, .artists:
                return self?.collection.configureCell(
                    of: CoverCollectionViewCell.self,
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

            if section.title.isEmpty { return UICollectionViewCell() }

            sectionHeader.title.text = section.title

            return sectionHeader
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LibraryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let snapshot = self.viewModel?.snapshot,
              let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }

        switch snapshot.sectionIdentifiers[indexPath.section] {

        case .albums, .playlists:
            coordinator?.showDetails(for: item)
        case .artists:
            coordinator?.showArtistPage(for: item.id)
        }
    }
}

// MARK: - LibraryViewModelDelegate
extension LibraryViewController: LibraryViewModelDelegate {

    func didFailLoading(with error: any Error) {

        guard let data = dataSource?.snapshot(),
              data.numberOfItems == 0 else {
            return
        }

        showErrorState(for: error) { [weak self] in
            self?.retryFetch()
        }
    }

    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        clearContentUnavailableState()

        dataSource?.apply(snapshot)
    }
}
