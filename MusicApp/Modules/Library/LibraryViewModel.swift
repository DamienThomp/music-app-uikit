//
//  LibraryViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import UIKit

protocol LibraryViewModelDelegate: AnyObject {

    @MainActor func reloadData()
}

class LibraryViewModel {

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<LibrarySections, BrowseItem>

    private(set) var snapshot = DataSourceSnapshot()

    weak var delegate: LibraryViewModelDelegate?

    var dataSource: LibraryDataSource?

    init(dataSource: LibraryDataSource) {
        self.dataSource = dataSource
    }

    func fetchData() {
        dataSource?.fetchDispayData()
    }

    func createInitialSnapshot() {
        snapshot.appendSections(LibrarySections.allCases)
    }

    private func updateSnapshot(for section: LibrarySections, with items: [BrowseItem]) {
        snapshot.appendItems(items, toSection: section)
    }

    private func configureViewModel(for section: LibrarySections, with data: Codable) -> [BrowseItem]? {
        
        switch section {
        case .albums:
            guard let data = data as? AlbumsResponse else { return nil }

            return data.items?.compactMap { item in
               return BrowseItem(type: .album, data: item.album)
            }
        case .playlists:
            guard let data = data as? SavedPlaylistsResponse else { return nil }

            return data.items.compactMap { item in
                BrowseItem(type: .playlist, data: item)
            }
        case .artists:
            guard let data = data as? SavedArtistsResponse else { return nil }

            return data.artists.items.compactMap { item in
                BrowseItem(
                    id: item.id,
                    title: item.name,
                    subTitle: "",
                    image: item.images?.imageUrl,
                    type: item.type
                )
            }
        }
    }
}

//MARK: - Data Source Delegate
extension LibraryViewModel: LibraryDataSourceDelegate {

    func didLoadData(for section: LibrarySections, with data: Codable) {

        guard let items = configureViewModel(for: section, with: data) else { return }

        updateSnapshot(for: section, with: items)
    }

    func didFinishLoading() {
        delegate?.reloadData()
    }
}
