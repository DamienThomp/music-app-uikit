//
//  FeaturedPlaylists.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-29.
//

import Foundation

struct FeaturedPlaylists: Codable {

    let message: String
    let playlists: Playlist

    struct Playlist: Codable {

        let href: URL
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [PlaylistItems]
    }
}

struct PlaylistItems: Codable {

    let collaborative: Bool
    let description: String
    let externalUrls: [String : String]
    let href: String
    let id: String
    let images: [Images]?
    let name: String
    let owner: Owner
    let type: ItemType
    let uri: String
}

/*
{
  "message": "Popular Playlists",
  "playlists": {
    "href": "https://api.spotify.com/v1/me/shows?offset=0&limit=20",
    "limit": 20,
    "next": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
    "offset": 0,
    "previous": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
    "total": 4,
    "items": [
      {
        "collaborative": false,
        "description": "string",
        "external_urls": {
          "spotify": "string"
        },
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
        "owner": {
          "external_urls": {
            "spotify": "string"
          },
          "followers": {
            "href": "string",
            "total": 0
          },
          "href": "string",
          "id": "string",
          "type": "user",
          "uri": "string",
          "display_name": "string"
        },
        "public": false,
        "snapshot_id": "string",
        "tracks": {
          "href": "string",
          "total": 0
        },
        "type": "string",
        "uri": "string"
      }
    ]
  }
}*/
