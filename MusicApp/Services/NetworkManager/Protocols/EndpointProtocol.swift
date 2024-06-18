//
//  EndpointProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-02-19.
//

import Foundation

public enum HTTPMethod: String {

    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum ContentType: String {

    case applicationJson = "application/json"
}

protocol EndpointProtocol {

    var baseUrl: String { get }

    var apiVersion: String { get }

    var path: String { get }

    var httpMethod: HTTPMethod { get }

    var contentType: ContentType? { get }

    var headers: [String: String]? { get }

    var parameters: [String: Any?]? { get }

    var queryItems: [URLQueryItem]? { get }

    var cachePolicy: URLRequest.CachePolicy { get }
}

// MARK: - Default Values
extension EndpointProtocol {

    var baseUrl: String {
        return AuthConstants.apiBaseUrl
    }

    var apiVersion: String {
        return AuthConstants.apiVersion
    }

    var contentType: ContentType? {
        return .applicationJson
    }

    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any?]? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
}
