//
//  Playlist.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-02-15.
//

import Foundation

struct Playlist: Codable {

    let collaborative: Bool
    let description: String
    let followers: Followers?
    let href: URL?
    let id: String
    let images: [Images]?
    let name: String
    let owner: Owner
    let tracks: Tracks
}

struct Tracks: Codable {

    let href: URL?
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
    let items: [PlaylistTrackItem]
}

struct PlaylistTrackItem: Codable {

    let addedAt: String?
    let addedBy: AddedByItem?
    let track: Track?
}

struct AddedByItem: Codable {

    let externalUrls: [String: String]?
    let followers: Followers?
    let href: URL?
    let id: String
    let type: String
    let uri: String
}

/*

 {
   "collaborative": false,
   "description": "string",
   "external_urls": {
     "spotify": "string"
   },
   "followers": {
     "href": "string",
     "total": 0
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
     "href": "https://api.spotify.com/v1/me/shows?offset=0&limit=20",
     "limit": 20,
     "next": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
     "offset": 0,
     "previous": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
     "total": 4,
     "items": [
       {
         "added_at": "string",
         "added_by": {
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
           "uri": "string"
         },
         "is_local": false,
         "track": {
           "album": {
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
             ]
           },
           "artists": [
             {
               "external_urls": {
                 "spotify": "string"
               },
               "followers": {
                 "href": "string",
                 "total": 0
               },
               "genres": ["Prog rock", "Grunge"],
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
           ],
           "available_markets": ["string"],
           "disc_number": 0,
           "duration_ms": 0,
           "explicit": false,
           "external_ids": {
             "isrc": "string",
             "ean": "string",
             "upc": "string"
           },
           "external_urls": {
             "spotify": "string"
           },
           "href": "string",
           "id": "string",
           "is_playable": false,
           "linked_from": {
           },
           "restrictions": {
             "reason": "string"
           },
           "name": "string",
           "popularity": 0,
           "preview_url": "string",
           "track_number": 0,
           "type": "track",
           "uri": "string",
           "is_local": false
         }
       }
     ]
   },
   "type": "string",
   "uri": "string"
 }



 */
