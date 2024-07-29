//
//  ItemDetailsViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-22.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    weak var coordinator: ItemDetailsCoordinator?
    var viewModel: ItemDetailsViewModel?

    typealias DataSource = UICollectionViewDiffableDataSource<ItemDetailsSection, BrowseItem>

    private var collection: UICollectionView!

    private var dataSource: DataSource?

    var cellItemData: BrowseItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

        viewModel?.fetchData(with: cellItemData)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collection?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 20, right: 0)
    }

    func configure() {

        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
    }
}

// MARK: - Collection View Configuration
extension ItemDetailsViewController {
    
    private func configureCollectionView() {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSectionLayout(for: sectionIndex)
        }

        layout.register(
            SectionDecorator.self,
            forDecorationViewOfKind: SectionDecorator.reuseIdentifier
        )

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config

        collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)

        collection.contentInsetAdjustmentBehavior = .never
        collection.delegate = self

        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(collection)
    }

    private func registerCells() {

        collection.register(
            AlbumTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.reuseIdentifier
        )
        collection.register(
            PlaylistTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaylistTrackCollectionViewCell.reuseIdentifier
        )

        collection.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")

        collection.register(
            CoverCollectionViewCell.self,
            forCellWithReuseIdentifier: CoverCollectionViewCell.reuseIdentifier
        )

        collection.register(
            AlbumsPageHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier:
                AlbumsPageHeader.reuseIdentifier
        )

        collection.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {

        switch sectionIndex {
        case 0:
            return CollectionUIHelper.createTrackListLayout()
        case 1:
            return CollectionUIHelper.createItemViewLayout()
        default:
            return CollectionUIHelper.createItemViewLayout()
        }
    }
}

// MARK: - Data Source Configuration
extension ItemDetailsViewController {

    private func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource(collectionView: collection,
                                                        cellProvider: { [weak self] _, indexPath, item in

            if item.type == .playlist || item.type == .playlistTrack {
                return self?.dequeCellForPlaylistView(with: item, at: indexPath)
            }

            if item.type == .album || item.type == .albumTrack {
                return self?.dequeCellForAlbumView(with: item, at: indexPath)
            }

            return UICollectionViewCell()
        })
    }

    private func configureDataSourceSupplement() {

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            
            switch indexPath.section {
            case 0:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: AlbumsPageHeader.reuseIdentifier,
                    for: indexPath
                ) as? AlbumsPageHeader else {
                    return UICollectionViewCell()
                }
                
                guard let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                    return UICollectionViewCell()
                }
                
                guard let header = section.sectionHeader else {
                    return UICollectionViewCell()
                }
                
                sectionHeader.configureView(
                    with: AlbumsPageHeaderViewModel(
                        title: header.title,
                        artisName: header.subtitle ?? "",
                        coverImage: header.image,
                        genre: [],
                        type: header.type ?? .album
                    )
                )
                
                return sectionHeader
                
            case 1:
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

                guard let header = section.sectionHeader else {
                    return UICollectionViewCell()
                }

                sectionHeader.title.text = header.title

                return sectionHeader
            default:
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

                guard let header = section.sectionHeader else {
                    return UICollectionViewCell()
                }

                sectionHeader.title.text = header.title

                return sectionHeader
            }
        }
    }

    private func dequeCellForPlaylistView(with item: BrowseItem, at indexPath: IndexPath) -> UICollectionViewCell {
        return collection.configureCell(of: PlaylistTrackCollectionViewCell.self, for: item, at: indexPath)
    }

    private func dequeCellForAlbumView(with item: BrowseItem, at indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collection.configureCell(of: AlbumTrackCollectionViewCell.self, for: item, at: indexPath)
        case 1:
            return collection.configureCell(of: CoverCollectionViewCell.self, for: item, at: indexPath)
        default:
            return collection.configureCell(of: CoverCollectionViewCell.self, for: item, at: indexPath)
        }
    }
}

// MARK: - Collection View Delegate
extension ItemDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let snapshot = self.viewModel?.snapshot,
              let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }

        switch snapshot.sectionIdentifiers[indexPath.section].sectionType {
        case .main:
            print("item click: \(item.title)")
        case .related:
            coordinator?.showChildDetails(with: item)
        }
    }
}

// MARK: - ItemDetailViewModelDelegate
extension ItemDetailsViewController: ItemDetailViewModelDelegate {
    
    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        dataSource?.apply(snapshot)
    }
}
