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

    init(type: ItemType, data: PlaylistItems) {
        self.id = data.id
        self.title = data.name
        self.subTitle = data.owner.displayName ?? ""
        self.image = data.images.imageUrl
        self.type = type
    }

    init(type: ItemType, data: Album) {
        self.id = data.id
        self.title = data.name
        self.subTitle = data.artists.first?.name ?? ""
        self.image = data.images?.imageUrl
        self.type = type
    }

    init(type: ItemType, data: AlbumResponse) {
        self.id = data.id
        self.title = data.name
        self.subTitle = data.artists.first?.name ?? ""
        self.image = data.images?.imageUrl
        self.type = type
    }

    init(type: ItemType, data: Track) {
        self.id = data.id
        self.title = data.name
        self.subTitle = type == .playlistTrack ? (data.artists.first?.name ?? "") : "\(data.trackNumber)"
        self.image = data.album.images?.imageUrl
        self.type = type
    }
}
