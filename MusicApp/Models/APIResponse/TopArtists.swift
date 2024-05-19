//
//  TopArtists.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-06.
//

import Foundation

struct TopArtists: Codable {

    let href: URL?
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
    let items: [ArtistItem]
}

struct ArtistItem: Codable {

    let id: String
    let genres: [String]
    let name: String
    let images: [Images]?
    let type: ItemType
}


/*
 {
   "href": "https://api.spotify.com/v1/me/shows?offset=0&limit=20",
   "limit": 20,
   "next": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
   "offset": 0,
   "previous": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
   "total": 4,
   "items": [
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
   ]
 }

 */
