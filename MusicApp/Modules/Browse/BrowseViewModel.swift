//
//  BrowseViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import Foundation

protocol BrowseViewModelDelegate: AnyObject {

    func reloadData(for section: BrowseSections, with data: [BrowseItem])
}

class BrowseViewModel {

    weak var delegate: BrowseViewModelDelegate?
    var dataSource: BrowseDataSource?

    init(dataSource: BrowseDataSource) {
        self.dataSource = dataSource
    }

    func fetchData() async throws {
        dataSource?.fetchDispayData()
    }

    private func configureViewModel(for section: BrowseSections, with data: Codable) -> [BrowseItem]? {

        switch section {
        case .newReleases:

            guard let data = data as? NewReleases else { return nil }

            return data.albums.items.compactMap { album in
                BrowseItem(
                    id: album.id,
                    title: album.name,
                    subTitle: album.artists.first?.name ?? "",
                    image: album.imageUrl
                )
            }
        case .featured:

            guard let data = data as? FeaturedPlaylists else { return nil }

            return data.playlists.items.compactMap { playlist in
                BrowseItem(
                    id: playlist.id,
                    title: playlist.name,
                    subTitle: playlist.owner.displayName ?? "",
                    image: playlist.imageUrl
                )
            }
        case .recommended:

            guard let data = data as? Recommendations else { return nil }

            return data.tracks.compactMap { track in
                BrowseItem(
                    id: track.id,
                    title: track.name,
                    subTitle: track.artists.first?.name ?? "",
                    image: track.album.imageUrl
                )
            }
        }
    }
}

extension BrowseViewModel: BrowseDataSourceDelegate {

    func didLoadData(for section: BrowseSections, with data: Codable) {

        guard let items = configureViewModel(for: section, with: data) else { return }

        delegate?.reloadData(for: section, with: items)
    }
}
