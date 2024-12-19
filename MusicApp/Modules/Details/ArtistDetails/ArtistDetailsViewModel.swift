//
//  ArtistDetailsViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

enum ArtistDetailSectionType: Hashable, CaseIterable {

    case main
    case album
    case tracks
}

struct ArtistDetailsSection: Hashable {

    let sectionType: ArtistDetailSectionType
    let sectionHeader: ArtistDetailsSectionHeader?
    let items: [BrowseItem]
}

struct ArtistDetailsSectionHeader: Hashable {

    let id: String
    let title: String
    let image: URL?

    init(
        id: String,
        title: String,
        image: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.image = image
    }
}

protocol ArtistDetailViewModelDelegate: AnyObject {

    @MainActor func reloadData()
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didUpdateFollowedStatus()
    @MainActor func didFailToFollowArtist()
}

class ArtistDetailsViewModel {

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ArtistDetailsSection, BrowseItem>

    private(set) var snapshot = DataSourceSnapshot()

    weak var delegate: ArtistDetailViewModelDelegate?
    var dataSource: ArtistDetailsDataSource?

    var sections = [ArtistDetailsSection]()

    var isFollowingArtist: Bool {
        dataSource?.isFollowingArtist ?? false
    }

    init(dataSource: ArtistDetailsDataSource?) {
        self.dataSource = dataSource
    }

    func fetchData(for id: String?) {

        guard let id else { return }

        dataSource?.fetchDisplayData(for: id)
    }

    func updateFollowStatus(for id: String) {
        dataSource?.updateFollowStatus(with: id)
    }
}

extension ArtistDetailsViewModel {

    private func updateSnapShot() {

        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
    }

    private func configureSection(for section: ArtistDetailSectionType, with data: Codable) {

        switch section {
        case .main:

            guard let data = data as? ArtistDetailsResponse else { return }

            let sectionHeader = ArtistDetailsSectionHeader(id: data.id, title: data.name, image: data.images.imageUrl)

            let sectionData = ArtistDetailsSection(
                sectionType: section,
                sectionHeader: sectionHeader,
                items: []
            )

            sections.append(sectionData)

        case .album:
            guard let data = data as? ArtistAlbumsResponse else { return }

            let section = ArtistDetailsSection(
                sectionType: section,
                sectionHeader: ArtistDetailsSectionHeader(
                    id: UUID().uuidString,
                    title: "Albums by \(data.items.first?.artists.first?.name ?? "")"
                ),
                items: data.items.compactMap(BrowseItem.init)
            )
            sections.append(section)
        case .tracks:
            guard let data = data as? TrackResponse else { return }

            let section = ArtistDetailsSection(
                sectionType: section,
                sectionHeader: ArtistDetailsSectionHeader(
                    id: UUID().uuidString,
                    title: "Tracks"
                ),
                items: data.tracks.compactMap(BrowseItem.init)
            )
            sections.append(section)
        }
    }
}

extension ArtistDetailsViewModel: ArtistDetailsDataSourceDelegate {

    func didLoadData(for sectionType: ArtistDetailSectionType, with data: Codable) {
        configureSection(for: sectionType, with: data)
    }

    func didFinishLoading() {
        updateSnapShot()
        delegate?.reloadData()
    }

    func didFailLoading(with error: Error) {
        // todo
    }

    func didUpdateFollowedStatus() {
        delegate?.didUpdateFollowedStatus()
    }

    func didFailToFollowArtist() {
        //
    }
}
