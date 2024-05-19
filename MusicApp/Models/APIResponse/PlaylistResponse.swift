//
//  PlaylistResponse.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-11.
//

import Foundation

struct PlaylistResponse: Codable {

    let collaborative: Bool
    let description: String
    let followers: Followers?
    let href: URL?
    let id: String
    let images: [Images]?
    let name: String
    let owner: Owner
    let tracks: Tracks
    let type: ItemType
    let uri: String

    struct Tracks: Codable {

        let href: URL?
        let limit: Int
        let next: URL?
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [TrackItem]

    }

    struct Track: Codable {

        let album: Album
        let artists: [Artist]
        let availableMarkets: [String]
        let discNumber: Int
        let durationMs: Int
        let explicit: Bool
        let externalIds: ExternalIds
        let externalUrls: [String: String]
        let href: String
        let id: String
        let isPlayable: Bool?
        let linkedFrom: [String: String]?
        let restrictions: Restrictions?
        let name: String
        let popularity: Int
        let previewUrl: String?
        let trackNumber: Int
        let type: ItemType
        let uri: String
        let isLocal: Bool
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
             "available_markets": [
               "CA",
               "BR",
               "IT"
             ],
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
           ],
           "available_markets": [
             "string"
           ],
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
           "linked_from": {},
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
