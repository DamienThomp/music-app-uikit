//
//  BrowseItem.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import Foundation

struct BrowseItem: CellItemProtocol, Hashable {

    let id: String
    let title: String
    let subTitle: String
    let image: URL?
    let type: ItemType?
}

extension BrowseItem {

    init(_ data: PlaylistItems) {
        self.id = data.id
        self.title = data.name
        self.subTitle = data.owner.displayName ?? ""
        self.image = data.images.imageUrl
        self.type = data.type
    }

    init(_ data: Album) {
        self.id = data.id
        self.title = data.name
        self.subTitle = data.artists.first?.name ?? ""
        self.image = data.images?.imageUrl
        self.type = data.type
    }

    init(_ data: AlbumResponse) {
        self.id = data.id
        self.title = data.name
        self.subTitle = data.artists.first?.name ?? ""
        self.image = data.images?.imageUrl
        self.type = data.type
    }

    init(_ data: Track) {
        self.id = data.id
        self.title = data.name
        self.subTitle = data.type == .playlistTrack || data.type == .track ? (data.artists.first?.name ?? "") : "\(data.trackNumber)"
        self.image = data.album.images?.smallImageUrl
        self.type = data.type
    }

    init(_ data: Artist) {
        self.id = data.id
        self.title = data.name
        self.subTitle = ""
        self.image = data.images?.imageUrl
        self.type = data.type
    }

    init(_ data: CategoryItems.Category) {
        self.id = data.id
        self.title = data.name
        self.subTitle = ""
        self.image = data.icons?.first?.url
        self.type = .category
    }
}
