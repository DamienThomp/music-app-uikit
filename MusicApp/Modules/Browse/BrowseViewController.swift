//
//  BrowseViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

class BrowseViewController: UIViewController {

    weak var coordinator: BrowseCoordinator?
    var viewModel: BrowseViewModel?

    typealias DataSource = UICollectionViewDiffableDataSource<BrowseSections, BrowseItem>

    private var collection: UICollectionView!

    private var dataSource: DataSource?

    let profileButton = UIButton(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        viewModel?.createInitialSnapshot()
        showLoadingState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureViewController()

        viewModel?.fetchData()

        setNeedsUpdateContentUnavailableConfiguration()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        profileButton.removeFromSuperview()
    }

    private func configureViewController() {

        let config = UIImage.SymbolConfiguration(pointSize: 22)
        let barButtonImage = UIImage(systemName: "person.circle", withConfiguration: config)

        let profileButtonAction = UIAction { [weak self] _ in
            self?.coordinator?.presentProfile()
        }
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = barButtonImage

        profileButton.configuration = buttonConfig
        profileButton.addAction(profileButtonAction, for: .touchUpInside)
        profileButton.translatesAutoresizingMaskIntoConstraints = false

        if let navBar = navigationController?.navigationBar {
            navBar.subviews.first(where: \.clipsToBounds)?.addSubview(profileButton)
            NSLayoutConstraint.activate([
                profileButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor),
                profileButton.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -10)
            ])
        }

        view.backgroundColor = .systemBackground
    }

    private func configure() {

        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
    }
}

// MARK: - Collection View Configuration
extension BrowseViewController {
    
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

        collection.register(
            FeaturedCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier
        )

        collection.register(
            PlaylistTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaylistTrackCollectionViewCell.reuseIdentifier
        )
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {

        guard let snapshot = self.viewModel?.snapshot else { return nil }

        switch snapshot.sectionIdentifiers[sectionIndex] {
        case .newReleases:
            return CollectionUIHelper.createFeaturedHorizontalSection()
        case .featured:
            return CollectionUIHelper.createTwoRowHorizontalSection()
        case .recommended:
            return CollectionUIHelper.createMultiRowHorizontalListSection()
        }
    }
}

// MARK: - Data Source Configuration
extension BrowseViewController {
    
    private func configureDataSource() {

        dataSource = DataSource(collectionView: collection, cellProvider: { [weak self] _, indexPath, item in

            guard let snapshot = self?.viewModel?.snapshot else { return UICollectionViewCell() }

            switch snapshot.sectionIdentifiers[indexPath.section] {
            case .newReleases:
                return self?.collection.configureCell(
                    of: FeaturedCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            case .featured:
                return self?.collection.configureCell(
                    of: CoverCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            case .recommended:
                return self?.collection.configureCell(
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

// MARK: - UICollectionViewDelegate {
extension BrowseViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let snapshot = self.viewModel?.snapshot,
              let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }

        switch snapshot.sectionIdentifiers[indexPath.section] {
        case .newReleases, .featured:
            coordinator?.showDetails(for: item)
        case .recommended:
            return
        }
    }
}

// MARK: - BrowseViewModelDelegate
extension BrowseViewController: BrowseViewModelDelegate {
    
    func didFailLoading(with error: Error) {

        showErrorState(for: error)
    }

    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        clearContentUnavailableState()

        dataSource?.apply(snapshot)
    }
}
