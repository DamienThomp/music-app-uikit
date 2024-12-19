//
//  ArtistDetailsViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

enum ArtistDetailSection: Hashable, CaseIterable {
    
    case albums
    case tracks

    var title: String? {

        switch self {
        case .albums:
            return "Albums"
        case .tracks:
            return "Tracks"
        }
    }
}

protocol ArtistDetailViewModelDelegate: AnyObject {

    @MainActor func reloadData()
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didUpdateSavedStatus()
    @MainActor func didFailToSaveItem()
}

class ArtistDetailsViewModel {

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ArtistDetailSection, BrowseItem>

    private(set) var snapshot = DataSourceSnapshot()

    weak var delegate: ArtistDetailViewModelDelegate?
    var dataSource: ArtistDetailsDataSource?

    var sections = [ArtistDetailSection]()
    var header: BrowseItem?

    var isFollowingArtist: Bool {
        dataSource?.isFollowingArtist ?? false
    }

    init(dataSource: ArtistDetailsDataSource?) {
        self.dataSource = dataSource
    }

    func fetchData(for id: String?) {

        guard let id else { return }

        print("fetch data for id: \(id)")

        dataSource?.fetchDisplayData(for: id)
    }
}

extension ArtistDetailsViewModel {
    
    func createInitialSnapshot() {
        snapshot.appendSections(ArtistDetailSection.allCases)
    }

    private func updateSnapshot(for section: ArtistDetailSection, with items: [BrowseItem]) {
        snapshot.appendItems(items, toSection: section)
    }

    private func configureViewModel(for section: ArtistDetailSection, with data: Codable) -> [BrowseItem]? {

        switch section {
        case .albums:

            guard let data = data as? ArtistAlbumsResponse else { return nil }

            return data.items.compactMap(BrowseItem.init)
        case .tracks:

            guard let data = data as? TrackResponse else { return nil }

            return data.tracks.compactMap(BrowseItem.init)
        }
    }

    private func updateHeader(with data: ArtistDetailsResponse) {
        
        let headerItem = BrowseItem(id: data.id, title: data.name, subTitle: "", image: data.images.imageUrl, type: nil)

        header = headerItem
    }
}

extension ArtistDetailsViewModel: ArtistDetailsDataSourceDelegate {

    func didLoadHeader(with data: ArtistDetailsResponse) {
        updateHeader(with: data)
    }

    func didLoadData(for sectionType: ArtistDetailSection, with data: Codable) {

        guard let items = configureViewModel(for: sectionType, with: data) else { return }

        updateSnapshot(for: sectionType, with: items)
    }

    func didFinishLoading() {
        delegate?.reloadData()
    }
    
    func didFailLoading(with error: Error) {
        // todo
    }
    
    func didUpdateSavedStatus() {
        // todo
    }
    
    func didFailToSaveItem() {
        // todo
    }
}
