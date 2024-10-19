//
//  LibraryViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import UIKit

enum LibrarySections: Hashable, CaseIterable {

    case albums
    case playlists
    case artists

    var title: String {

        switch self {
        case .albums:
            "Albums"
        case .playlists:
            "Playlists"
        case .artists:
            "Followed Artists"
        }
    }
}

protocol LibraryViewModelDelegate: AnyObject {

    @MainActor func reloadData()
    @MainActor func didFailLoading(with error: Error)
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
        dataSource?.fetchDisplayData()
    }

    func createInitialSnapshot() {

        snapshot.appendSections(LibrarySections.allCases)
    }

    private func updateSnapshot(for section: LibrarySections, with items: [BrowseItem]) {

        let previousItems = snapshot.itemIdentifiers(inSection: section)
        snapshot.deleteItems(previousItems)

        snapshot.appendItems(items, toSection: section)
    }

    private func configureViewModel(for section: LibrarySections, with data: Codable) -> [BrowseItem]? {
        
        switch section {
        case .albums:

            guard let data = data as? AlbumsResponse else { return nil }

            return data.items?.compactMap { BrowseItem($0.album) }
        case .playlists:

            guard let data = data as? SavedPlaylistsResponse else { return nil }

            return data.items.compactMap(BrowseItem.init)
        case .artists:
            
            guard let data = data as? SavedArtistsResponse else { return nil }

            return data.artists.items.compactMap(BrowseItem.init)
        }
    }
}

// MARK: - Data Source Delegate
extension LibraryViewModel: LibraryDataSourceDelegate {
    
    func didFailLoading(with error: any Error) {

        delegate?.didFailLoading(with: error)
    }
    
    func didLoadData(for section: LibrarySections, with data: Codable) {

        guard let items = configureViewModel(for: section, with: data) else { return }

        updateSnapshot(for: section, with: items)
    }

    func didFinishLoading() {
        delegate?.reloadData()
    }
}
