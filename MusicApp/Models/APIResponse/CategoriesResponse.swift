//
//  Categories.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-07.
//

import Foundation

struct CategoriesResponse: Codable {

    let categories: CategoryItems
}

struct CategoryItems: Codable {

    let href: URL?
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
    let items: [Category]

    struct Category: Codable {

        let href: URL?
        let icons: [Icons]?
        let name: String
        let id: String
    }

    struct Icons: Codable {

        let url: URL?
        let height: Int?
        let width: Int?
    }
}
