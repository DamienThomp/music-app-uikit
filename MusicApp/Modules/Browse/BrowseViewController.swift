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

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        viewModel?.createInitialSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.fetchData()
    }

    private func configureViewController() {

        view.backgroundColor = .systemBackground
    }

    private func configure() {

        configureViewController()
        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
    }
}

//MARK: - Collection View Configuration
extension BrowseViewController {
    
    private func configureCollectionView() {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSectionLayout(for: sectionIndex)
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
        print("register cells")

        collection.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")

        collection.register(CoverCollectionViewCell.self, forCellWithReuseIdentifier: CoverCollectionViewCell.reuseIdentifier)

        collection.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier)

        collection.register(PlaylistTrackCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistTrackCollectionViewCell.reuseIdentifier)
    }

    private func configureCell<T: CellConfigurationProtocol>(
        of cellType: T.Type,
        for item: CellItemProtocol,
        at indexPath: IndexPath
    ) -> T {

        guard let cell = collection.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("unable to dequeue cell: \(cellType)")
        }

        cell.configure(with: item)

        return cell
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {

        guard let snapshot = self.viewModel?.snapshot else { return nil }

        switch snapshot.sectionIdentifiers[sectionIndex] {
        case .newReleases:
            print("new releases")
            return CollectionUIHelper.createFeaturedHorizontalSection()
        case .featured:
            print("featured")
            return CollectionUIHelper.createTwoRowHorizontalSection()
        case .recommended:
            print("recommended")
            return CollectionUIHelper.createMultiRowHorizontalListSection()
        }
    }
}

//MARK: - Data Source Configuration
extension BrowseViewController {
    
    private func configureDataSource() {

        dataSource = DataSource(collectionView: collection,
                                cellProvider: {
            collectionView,
            indexPath,
            item in
            
            guard let snapshot = self.viewModel?.snapshot else { return UICollectionViewCell() }
            
            switch snapshot.sectionIdentifiers[indexPath.section] {
            case .newReleases:
                return self.configureCell(
                    of: FeaturedCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            case .featured:
                return self.configureCell(
                    of: CoverCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            case .recommended:
                return self.configureCell(
                    of: PlaylistTrackCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            }
        })
    }

    private func configureDataSourceSupplement() {

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in

            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {

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

//MARK: - UICollectionViewDelegate {
extension BrowseViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Handle calls to Coordinator for Routing
    }
}

//MARK: - BrowseViewModelDelegate
extension BrowseViewController: BrowseViewModelDelegate {

    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        dataSource?.apply(snapshot)
    }
}
