//
//  ArtistDetailsViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

protocol ArtistDetailViewModelDelegate: AnyObject {

    @MainActor func reloadData()
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didUpdateSavedStatus()
    @MainActor func didFailToSaveItem()
}

class ArtistDetailsViewModel {

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ItemDetailsSection, BrowseItem>

    private(set) var snapshot = DataSourceSnapshot()

    weak var delegate: ArtistDetailViewModelDelegate?
    var dataSource: ArtistDetailsDataSource?

    var isFollowingArtist: Bool {
        dataSource?.isFollowingArtist ?? false
    }

    init(dataSource: ArtistDetailsDataSource?) {
        self.dataSource = dataSource
    }
}

extension ArtistDetailsViewModel: ArtistDetailsDataSourceDelegate {

    func didFinishLoading() {
        // todo
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
