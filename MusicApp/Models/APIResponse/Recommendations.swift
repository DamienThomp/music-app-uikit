//
//  Recommendations.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-31.
//

import Foundation

struct Recommendations: Codable {

    let tracks: [Track]
}

struct ExternalIds: Codable {

      let isrc: String?
      let ean: String?
      let upc: String?
}
