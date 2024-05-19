//
//  AlbumResponse.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-10.
//

import Foundation

struct AlbumResponse: Codable {
    
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: [String : String]
    let href: String
    let id: String
    let images: [Images]?
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let restrictions: Restrictions?
    let type: ItemType
    let uri: String
    let artists: [Artist]
    let tracks: Track
    let copyright: [Copyright]?
    let genres: [String]
    let label: String
    let popularity: Int?

    struct Track: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [TrackItem]

    }

    struct TrackItem: Codable {

        let artists: [Artist]
        let availableMarkets: [String]
        let discNumber: Int
        let durationMs: Int
        let explicit: Bool
        let externalUrls: [String: String]
        let href: String
        let id: String
        let isPlayable: Bool?
        let restrictions: [String: String]?
        let name: String
        let previewUrl: String?
        let trackNumber: Int
        let type: String
        let uri: String
        let isLocal: Bool
    }

    struct Copyright: Codable {

        let text: String
        let type: String
    }

    var imageUrl: URL? {

        guard let images = self.images,
              images.count > 0
        else { return nil }

        return images.first?.url
    }

    var largeImage: URL? {

        guard let images = self.images,
              images.count > 0
        else { return nil }

        let largeImage = images.filter {

            guard let height = $0.height else { return false }

            return height >= 600
        }

        return !largeImage.isEmpty ? largeImage[0].url : images[0].url
    }
}

/*
{
  "album_type": "compilation",
  "total_tracks": 9,
  "available_markets": ["CA", "BR", "IT"],
  "external_urls": {
    "spotify": "string"
  },
  "href": "string",
  "id": "2up3OPMp9Tb4dAKM2erWXQ",
  "images": [
    {
      "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
      "height": 300,
      "width": 300
    }
  ],
  "name": "string",
  "release_date": "1981-12",
  "release_date_precision": "year",
  "restrictions": {
    "reason": "market"
  },
  "type": "album",
  "uri": "spotify:album:2up3OPMp9Tb4dAKM2erWXQ",
  "artists": [
    {
      "external_urls": {
        "spotify": "string"
      },
      "href": "string",
      "id": "string",
      "name": "string",
      "type": "artist",
      "uri": "string"
    }
  ],
  "tracks": {
    "href": "https://api.spotify.com/v1/me/shows?offset=0&limit=20",
    "limit": 20,
    "next": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
    "offset": 0,
    "previous": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
    "total": 4,
    "items": [
      {
        "artists": [
          {
            "external_urls": {
              "spotify": "string"
            },
            "href": "string",
            "id": "string",
            "name": "string",
            "type": "artist",
            "uri": "string"
          }
        ],
        "available_markets": ["string"],
        "disc_number": 0,
        "duration_ms": 0,
        "explicit": false,
        "external_urls": {
          "spotify": "string"
        },
        "href": "string",
        "id": "string",
        "is_playable": false,
        "linked_from": {
          "external_urls": {
            "spotify": "string"
          },
          "href": "string",
          "id": "string",
          "type": "string",
          "uri": "string"
        },
        "restrictions": {
          "reason": "string"
        },
        "name": "string",
        "preview_url": "string",
        "track_number": 0,
        "type": "string",
        "uri": "string",
        "is_local": false
      }
    ]
  },
  "copyrights": [
    {
      "text": "string",
      "type": "string"
    }
  ],
  "external_ids": {
    "isrc": "string",
    "ean": "string",
    "upc": "string"
  },
  "genres": ["Egg punk", "Noise rock"],
  "label": "string",
  "popularity": 0
}
*/
