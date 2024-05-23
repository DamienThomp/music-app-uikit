//
//  BrowseViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

protocol BrowseViewModelDelegate: AnyObject {
    
    @MainActor func reloadData()
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
        dataSource?.fetchDispayData()
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

            return data.albums.items.compactMap { album in
                BrowseItem(type: .album, data: album)
            }
        case .featured:

            guard let data = data as? FeaturedPlaylists else { return nil }

            return data.playlists.items.compactMap { playlist in
                BrowseItem(type: .playlist, data: playlist)
            }
        case .recommended:

            guard let data = data as? Recommendations else { return nil }

            return data.tracks.compactMap { track in
                BrowseItem(type: .playlistTrack, data: track)
            }
        }
    }
}

extension BrowseViewModel: BrowseDataSourceDelegate {
    
    func didFinishLoading() {
        delegate?.reloadData()
    }

    func didLoadData(for section: BrowseSections, with data: Codable) {

        guard let items = configureViewModel(for: section, with: data) else { return }

        updateSnapshot(for: section, with: items)
    }
}