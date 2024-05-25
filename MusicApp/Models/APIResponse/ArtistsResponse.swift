//
//  ArtistsResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import Foundation

struct SavedArtistsResponse: Codable {

    let artists: SavedArtists

    struct SavedArtists: Codable {

        let href: String?
        let limit: Int
        let total: Int
        let items: [Artist]
    }
}
/*
{
  "artists": {
    "href": "string",
    "limit": 0,
    "next": "string",
    "cursors": {
      "after": "string",
      "before": "string"
    },
    "total": 0,
    "items": [
      {
        "external_urls": {
          "spotify": "string"
        },
        "followers": {
          "href": "string",
          "total": 0
        },
        "genres": [
          "Prog rock",
          "Grunge"
        ],
        "href": "string",
        "id": "string",
        "images": [
          {
            "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
            "height": 300,
            "width": 300
          }
        ],
        "name": "string",
        "popularity": 0,
        "type": "artist",
        "uri": "string"
      }
    ]
  }
}*/
