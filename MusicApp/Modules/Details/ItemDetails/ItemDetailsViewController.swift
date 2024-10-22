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
    var saveButton = UIBarButtonItem()

    let notificationFeedback = UINotificationFeedbackGenerator()
    var mainHeader: AlbumsPageHeader?

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

        showLoadingState()

        viewModel?.fetchData(with: cellItemData)

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

        configureBackButton()
        configureNavBarButtons()
        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
    }

    func showErrorAlert() {
        
        let alertController = UIAlertController(
            title: "Error",
            message: "Could not complete action. please try again.",
            preferredStyle: .alert
        )

        let alerTAction = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(alerTAction)

        present(alertController, animated: true)
    }
}

// MARK: - Collection View Configuration
extension ItemDetailsViewController {

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
        saveButton = UIBarButtonItem(image: buttonImage, primaryAction: UIAction { [weak self] _ in

            guard let id = self?.cellItemData?.id else { return }

            self?.viewModel?.updateSavedAlbumStatus(for: id)
        })

        let menuButtonImage = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        let menuButton = UIBarButtonItem(image: menuButtonImage)

        navigationItem.rightBarButtonItems = [menuButton, saveButton]
    }

    private func configureCollectionView() {

        let layout = DynamicHeader { [weak self] sectionIndex, _ in
            return self?.createSectionLayout(for: sectionIndex)
        }

        layout.register(
            SectionDecorator.self,
            forDecorationViewOfKind: SectionDecorator.reuseIdentifier
        )

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
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

    func updateSaveButton() {

        guard let viewModel else { return }

        saveButton.image = UIImage(
            systemName: viewModel.isSavedAlbum ? "checkmark.circle.fill" : "plus.circle"
        )
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
                    return nil
                }
                
                guard let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                    return nil
                }
                
                guard let header = section.sectionHeader else {
                    return nil
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

                self?.mainHeader = sectionHeader
                self?.mainHeader?.delegate = self

                return sectionHeader

            case 1:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeader.reuseIdentifier,
                    for: indexPath
                ) as? SectionHeader else {
                    return UICollectionReusableView()
                }

                guard let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                    return UICollectionReusableView()
                }

                guard let header = section.sectionHeader else {
                    return UICollectionReusableView()
                }

                sectionHeader.title.text = header.title

                return sectionHeader
            default:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeader.reuseIdentifier,
                    for: indexPath
                ) as? SectionHeader else {
                    return UICollectionReusableView()
                }

                guard let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                    return UICollectionReusableView()
                }

                guard let header = section.sectionHeader else {
                    return UICollectionReusableView()
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

// MARK: - UIScrollViewDelegate
extension ItemDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationController else { return }
        mainHeader?.scrollViewDidScroll(scrollView: scrollView, navigationController: navigationController)
    }
}

// MARK: - AlbumPageHeaderDelegate
extension ItemDetailsViewController: AlbumPageHeaderDelegate {
    
    func didTapArtistNameButton() {
        // todo
    }
    
    func didTapPlayButton() {
        // todo
    }
    
    func didTapShuffleButton() {
        // todo
    }
    
    func titleLabel(show: Bool) {
        title = show ? mainHeader?.titleLabel.text : nil
    }
}

// MARK: - ItemDetailViewModelDelegate
extension ItemDetailsViewController: ItemDetailViewModelDelegate {

    func didFailLoading(with error: Error) {

        guard let data = dataSource?.snapshot(),
              data.numberOfItems == 0 else {
            return
        }

        showErrorState(for: error)
    }
    
    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        clearContentUnavailableState()

        updateSaveButton()

        dataSource?.apply(snapshot)
    }

    func didUpdateSavedStatus() {

        notificationFeedback.notificationOccurred(.success)
        
        updateSaveButton()
    }

    func didFailToSaveItem() {

        notificationFeedback.notificationOccurred(.error)

        showErrorAlert()
    }
}
