//
//  NewReleases.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-03-29.
//

import Foundation

struct NewReleases: Codable {

    let albums: Albums

    struct Albums: Codable {

        let href: URL
        let limit: Int
        let next: URL
        let offset: Int
        let previous: URL?
        let total: Int
        let items: [Album]
    }
}


//MARK: - Preview Data
extension NewReleases {

    static var preview: NewReleases {
        NewReleases(albums: Albums(
            href: URL(
                string: "https://api.spotify.com/v1/me/shows?offset=0&limit=20"
            )!,
            limit: 20,
            next: URL(
                string: "https://api.spotify.com/v1/me/shows?offset=1&limit=1"
            )!,
            offset: 0,
            previous: URL(
                string: "https://api.spotify.com/v1/me/shows?offset=1&limit=1"
            )!,
            total: 4,
            items: [
                Album(
                albumType: "compilation",
                totalTracks: 9,
                availableMarkets: [
                    "CA",
                    "BR",
                    "IT"
                ],
                externalUrls: ["spotify": "string"],
                href: "string",
                id: "2up3OPMp9Tb4dAKM2erWXQ",
                images: [
                    Images(
                    url: URL(
                        string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
                    )!,
                    height: 300,
                    width: 300
                )],
                name: "string",
                releaseDate: "1981-12",
                releaseDatePrecision: "year",
                restrictions: nil,
                type: .album,
                uri: "spotify:album:2up3OPMp9Tb4dAKM2erWXQ",
                artists: [
                    Artist(
                    externalUrls: ["spotify": "string"],
                    href: "",
                    id: "",
                    name: "",
                    type: .artist,
                    uri: ""
                )],
                genres: nil,
                tracks: nil
            )]))
    }
}
