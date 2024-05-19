//
//  Categories.swift
//  SpotifyCloneUIkit
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


/*
{
  "categories": {
    "href": "https://api.spotify.com/v1/me/shows?offset=0&limit=20",
    "limit": 20,
    "next": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
    "offset": 0,
    "previous": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
    "total": 4,
    "items": [
      {
        "href": "string",
        "icons": [
          {
            "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
            "height": 300,
            "width": 300
          }
        ],
        "id": "equal",
        "name": "EQUAL"
      }
    ]
  }
}
*/
