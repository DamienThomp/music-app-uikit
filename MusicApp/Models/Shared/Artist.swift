//
//  Artist.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-02-15.
//

import Foundation

struct Artist: Codable {

    let externalUrls: [String: String]
    let href: String
    let id: String
    let name: String
    let type: ItemType
    let uri: String
}
