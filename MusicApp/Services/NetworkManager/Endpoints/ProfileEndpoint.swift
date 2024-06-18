//
//  ProfileEndpoint.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-02-19.
//

import Foundation

enum ProfileEndpoint: EndpointProtocol {

    case user

    var path: String {
        return "/me"
    }

    var httpMethod: HTTPMethod {
        return .get
    }
}
