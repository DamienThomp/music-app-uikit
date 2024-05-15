//
//  RecommendationsEndpoint.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-03-31.
//

import Foundation

enum RecommendationsEndpoint: EndpointProtocol {

    case recommedations(limit: Int, genreSeeds: String? = nil, artistSeeds: String? = nil)
    case genre

    var httpMethod: HTTPMethod {
        .get
    }

    var path: String {

        switch self {
        case .recommedations:
            return "/recommendations"
        case .genre:
           return "/recommendations/available-genre-seeds"
        }
    }

    var queryItems: [URLQueryItem]? {

        switch self {
        case .recommedations(let limit, let genreSeeds, let artistSeeds):
            
            let queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)"),
                genreSeeds != nil ? URLQueryItem(name: "seed_genres", value: genreSeeds) : nil,
                artistSeeds != nil ? URLQueryItem(name: "seed_artists", value: artistSeeds) : nil
            ].compactMap { $0 }

            return queryItems
        case .genre:
            return [URLQueryItem(name: "limit", value: "10")]
        }
    }
}
