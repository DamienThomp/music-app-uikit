//
//  Profile.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-02-15.
//

import Foundation

struct ProfileResponse: Codable, Identifiable {

    let country: String?
    let displayName: String?
    let email: String?
    let explicitContent: ExplicitContent?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [Images]?
    let product: String?
    let type: String?
    let uri: String?

    struct ExplicitContent: Codable {
        let filterEnabled: Bool?
        let filterLocked: Bool?
    }

    struct ExternalUrls: Codable {
        let spotify: String?
    }

    struct Followers: Codable {
        let href: String?
        let total: Int?
    }

    struct Images: Codable {
        let url: String?
        let height: Int?
        let width: Int?
    }
}


/*
 {
   "country": "string",
   "display_name": "string",
   "email": "string",
   "explicit_content": {
     "filter_enabled": false,
     "filter_locked": false
   },
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
   "product": "string",
   "type": "string",
   "uri": "string"
 }
 */
