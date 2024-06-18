//
//  SearchEndpoint.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-13.
//

import Foundation

enum SearchType: String {
    
    case album
    case artist
    case track
    case show
    case episode
    case audiobook

    var type: String {
        self.rawValue
    }
}

enum SearchEndpoint: EndpointProtocol {

    case search(query: String, searchType: [SearchType])

    var path: String { "/search" }

    var httpMethod: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {

        switch self {
        case .search(let query, let searchType):
            return [
                URLQueryItem(
                    name: "type",
                    value: searchType.map { $0.type }.joined(separator: ",")
                ),
                URLQueryItem(
                    name: "q",
                    value: query
                )
            ]
        }
    }
}
