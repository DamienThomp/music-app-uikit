//
//  ItemDetailsViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-22.
//

import UIKit

protocol ItemDetailViewModelDelegate: AnyObject {

    @MainActor func reloadData()
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didUpdateSavedStatus()
    @MainActor func didFailToSaveItem()
}

class ItemDetailsViewModel {

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ItemDetailsSection, BrowseItem>

    private(set) var snapshot = DataSourceSnapshot()

    weak var delegate: ItemDetailViewModelDelegate?
    var dataSource: ItemDetailsDataSource?

    var sections = [ItemDetailsSection]()

    var isSavedAlbum: Bool {
        dataSource?.isSavedAlbum ?? false
    }

    init(dataSource: ItemDetailsDataSource) {
        self.dataSource = dataSource
    }

    func fetchData(with data: BrowseItem?) {

        guard let data,
              let type = data.type else { return }

        dataSource?.fetchDispayData(with: data.id, for: type)
    }

    func updateSavedAlbumStatus(for albumId: String) {
        dataSource?.updateSavedAlbumStatus(with: albumId)
    }
}

extension ItemDetailsViewModel {

    func updateSnapShot() {

        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
    }

    func configureSection(for section: ItemDetailsSectionType, with data: Codable, of type: ItemType) {
       
        switch section {
        case .main:
            if type == .playlist {
                guard let data = data as? PlaylistResponse else { return }

                let sectionHeader = ItemDetailSectionHeader(data)

                let sectionData = ItemDetailsSection(
                    sectionType: section,
                    sectionHeader: sectionHeader,
                    items: data.tracks.items.compactMap({ item in
                        BrowseItem(
                            id: UUID().uuidString,
                            title: item.track?.name ?? "",
                            subTitle: item.track?.album.name ?? "",
                            image: item.track?.album.images?.imageUrl,
                            type: .playlist
                        )
                    })
                )

                sections.append(sectionData)
            }

            if type == .album {
                guard let data = data as? AlbumResponse else { return }

                let sectionHeader = ItemDetailSectionHeader(data)

                let items = data.tracks.items.compactMap { album in
                    BrowseItem(
                        id: album.id,
                        title: album.name,
                        subTitle: "\(album.trackNumber)",
                        image: nil,
                        type: .album
                    )
                }

                let sectionData = ItemDetailsSection(
                    sectionType: section,
                    sectionHeader: sectionHeader,
                    items: items
                )

                sections.append(sectionData)
            }

        case .related:
            guard let data = data as? ArtistResponse.Albums else { return }

            let section = ItemDetailsSection(
                sectionType: section,
                sectionHeader: ItemDetailSectionHeader(
                    id: UUID().uuidString,
                    title: "More by \(data.items.first?.artists.first?.name ?? "")"
                ),
                items: data.items.compactMap(BrowseItem.init)
            )
            sections.append(section)
        }
    }
}

extension ItemDetailsViewModel: ItemDetailsDataSourceDelegate {
    
    func didFailToSaveItem() {
        delegate?.didFailToSaveItem()
    }
    
    func didFailLoading(with error: Error) {

        delegate?.didFailLoading(with: error)
    }

    func didLoadData(
        for sectionType: ItemDetailsSectionType,
        with data: Codable,
        of type: ItemType
    ) {
        
        configureSection(for: sectionType, with: data, of: type)
    }

    func didFinishLoading() {

        updateSnapShot()
        delegate?.reloadData()
    }

    func didUpdateSavedStatus() {
        delegate?.didUpdateSavedStatus()
    }
}
