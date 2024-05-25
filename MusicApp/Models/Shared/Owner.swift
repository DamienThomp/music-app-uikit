//
//  Owner.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-08.
//

import Foundation

struct Owner: Codable, Hashable {

    let href: String
    let id: String
    let type: String
    let uri: String
    let displayName: String?
}
