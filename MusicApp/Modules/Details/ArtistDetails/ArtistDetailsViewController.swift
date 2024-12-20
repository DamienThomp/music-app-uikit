//
//  ArtistDetailsViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

class ArtistDetailsViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<ArtistDetailsSection, BrowseItem>

    weak var coordinator: ArtistDetailsCoordinator?
    var viewModel: ArtistDetailsViewModel?

    var artistId: String?
    var dataSource: DataSource?

    private var collection: UICollectionView!
    private var followButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configure()

        showLoadingState()

        viewModel?.fetchData(for: artistId)

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

    func configure() {

        configureCollectionView()
        configureBackButton()
        configureNavBarButtons()
        registerCells()
        configureDataSource()
        configureDataSource()
        configureDataSourceSupplement()
    }

    private func configureBackButton() {

        let imageConfig = UIImage.SymbolConfiguration(paletteColors: [.systemGray5, .systemGreen])
        let backImage = UIImage(systemName: "chevron.backward.circle.fill", withConfiguration: imageConfig)

        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage

        let backButton = UIBarButtonItem()
        backButton.title = ""

        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    private func configureNavBarButtons() {

        let imageConfig = UIImage.SymbolConfiguration(paletteColors: [.systemGreen])

        let buttonImage = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        followButton = UIBarButtonItem(image: buttonImage, primaryAction: UIAction { [weak self] _ in

            guard let id = self?.artistId else { return }

            self?.viewModel?.updateFollowStatus(for: id)
        })

        navigationItem.rightBarButtonItems = [followButton]
    }

    private func updateFollowButton() {

        guard let viewModel else { return }

        followButton.image = UIImage(
            systemName: viewModel.isFollowingArtist ? "checkmark.circle.fill" : "plus.circle"
        )
    }
}

// MARK: - Collection View Configuration
extension ArtistDetailsViewController {

    private func configureCollectionView() {

        let layout = DynamicHeader { [weak self] sectionIndex, _ in
            return self?.createSectionLayout(for: sectionIndex)
        }

        layout.register(
            SectionDecorator.self,
            forDecorationViewOfKind: SectionDecorator.reuseIdentifier
        )

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 60
        layout.configuration = config

        collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.contentInsetAdjustmentBehavior = .never
        collection.delegate = self

        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(collection)
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {

        switch sectionIndex {
        case 0:
            return CollectionUIHelper.createSingleItemBannerLayout()
        case 1:
            return CollectionUIHelper.createMultiRowHorizontalListSection()
        case 2:
            return CollectionUIHelper.createItemViewLayout()
        default:
            return CollectionUIHelper.createItemViewLayout()
        }
    }

    private func registerCells() {

        collection.register(
            PlaylistTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaylistTrackCollectionViewCell.reuseIdentifier
        )

        collection.register(
            CoverCollectionViewCell.self,
            forCellWithReuseIdentifier: CoverCollectionViewCell.reuseIdentifier
        )

        collection.register(
            ArtistDetailsHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier:
                ArtistDetailsHeaderView.reuseIdentifier
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

            switch item.type {
            case .album:
                return self?.collection.configureCell(
                    of: CoverCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            case .track:
                return self?.collection.configureCell(
                    of: PlaylistTrackCollectionViewCell.self,
                    for: item,
                    at: indexPath
                )
            default:
                return UICollectionViewCell()
            }
        })
    }

    private func configureDataSourceSupplement() {

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in

            switch indexPath.section {
            case 0:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ArtistDetailsHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? ArtistDetailsHeaderView else {
                    return UICollectionReusableView()
                }

                guard let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                    return UICollectionReusableView()
                }

                guard let header = section.sectionHeader else {
                    return UICollectionReusableView()
                }

                sectionHeader.configure(
                    with: BrowseItem(id: header.id, title: header.title, subTitle: "", image: header.image, type: nil)
                )

                return sectionHeader

            default:
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

                guard let header = section.sectionHeader else {
                    return nil
                }

                sectionHeader.title.text = header.title

                return sectionHeader
            }
        }
    }
}

extension ArtistDetailsViewController: UICollectionViewDelegate {

}

extension ArtistDetailsViewController: ArtistDetailViewModelDelegate {

    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        clearContentUnavailableState()

        dataSource?.apply(snapshot)
    }

    func didFailLoading(with error: Error) {
        showErrorState(for: error)
    }

    func didUpdateFollowedStatus() {
        updateFollowButton()
    }

    func didFailToFollowArtist() {
        //
    }
}
