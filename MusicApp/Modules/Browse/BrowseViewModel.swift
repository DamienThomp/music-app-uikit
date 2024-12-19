//
//  BrowseViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

protocol BrowseViewModelDelegate: AnyObject {
    
    @MainActor func reloadData()
    @MainActor func didFailLoading(with error: Error)
}

class BrowseViewModel {

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<BrowseSections, BrowseItem>

    private(set) var snapshot = DataSourceSnapshot()

    weak var delegate: BrowseViewModelDelegate?

    var dataSource: BrowseDataSource?

    init(dataSource: BrowseDataSource) {
        self.dataSource = dataSource
    }

    func fetchData() {
        dataSource?.fetchDisplayData()
    }

    func createInitialSnapshot() {
        snapshot.appendSections(BrowseSections.allCases)
    }

    private func updateSnapshot(for section: BrowseSections, with items: [BrowseItem]) {
        snapshot.appendItems(items, toSection: section)
    }

    private func configureViewModel(for section: BrowseSections, with data: Codable) -> [BrowseItem]? {

        switch section {
        case .newReleases:

            guard let data = data as? NewReleases else { return nil }

            return data.albums.items.compactMap(BrowseItem.init)
        case .featured:
            // Due to spotify deprecation of featured playlists endpoint
            // replaced with users saved playlists to fill the section
            guard let data = data as? SavedPlaylistsResponse else { return nil }

            let items = data.items

            return items.compactMap(BrowseItem.init)
        case .recommended:

            guard let data = data as? Recommendations else { return nil }

            return data.tracks.compactMap(BrowseItem.init)
        }
    }
}

extension BrowseViewModel: BrowseDataSourceDelegate {

    func didLoadData(for section: BrowseSections, with data: Codable) {

        guard let items = configureViewModel(for: section, with: data) else { return }

        updateSnapshot(for: section, with: items)
    }

    func didFinishLoading() {
        
        delegate?.reloadData()
    }

    func didFailLoading(with error: Error) {
        
        delegate?.didFailLoading(with: error)
    }
}
