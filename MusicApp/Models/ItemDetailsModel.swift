//
//  ItemDetailsModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-08-03.
//

import Foundation

enum ItemDetailsSectionType: Hashable {

    case main
    case related
}

struct ItemDetailsSection: Hashable {

    let sectionType: ItemDetailsSectionType
    let sectionHeader: ItemDetailSectionHeader?
    let items: [BrowseItem]
}

struct ItemDetailSectionHeader: Hashable {

    let id: String
    let title: String
    let subtitle: String?
    let image: URL?
    let type: ItemType?

    init(
        id: String,
        title: String,
        subtitle: String? = nil,
        image: URL? = nil,
        type: ItemType? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.type = type
    }
}

extension ItemDetailSectionHeader {

    init(_ item: PlaylistResponse) {

        self.id = item.id
        self.title = item.name
        self.subtitle = item.owner.displayName
        self.image = item.images?.imageUrl
        self.type = item.type
    }

    init(_ item: AlbumResponse) {
        
        self.id = item.id
        self.title = item.name
        self.subtitle = item.artists.first?.name ?? ""
        self.image = item.images?.imageUrl
        self.type = item.type
    }
}
