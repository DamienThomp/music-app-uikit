//
//  NetworkManager.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-02-15.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {

    var authManager: AuthManagerProtocol?

    private let validResponseCodes = 200...299

    private var authHeader: [String: String]? {

        guard let token = authManager?.accessToken else {
            return nil
        }

        return ["Authorization": "Bearer \(token)"]
    }

    @discardableResult
    public func request(for endpoint: EndpointProtocol) async throws -> Data {

        let request = try buildRequest(with: endpoint)

        return try await makeRequest(with: request)
    }

    private func makeRequest(with request: URLRequest) async throws -> Data {

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse,
              validResponseCodes.contains(response.statusCode)
        else {
            print("invalid response: \(response)")
            throw NetworkManagerErrors.invalidResponse
        }
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)

        return data
    }

    private func buildRequest(with endPoint: EndpointProtocol) throws -> URLRequest {

        guard let url = buildURL(with: endPoint) else {
            throw NetworkManagerErrors.invalidUrl
        }

        var request = URLRequest(url: url)

        request.httpMethod = endPoint.httpMethod.rawValue
        request.cachePolicy = endPoint.cachePolicy

        endPoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        authHeader?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        #if DEBUG
        print(String(describing: request))
        #endif

        return request
    }

    private func buildURL(with endPoint: EndpointProtocol) -> URL? {

        guard var url = URL(string: endPoint.baseUrl) else { return nil }

        url.appendPathComponent(endPoint.apiVersion)
        url.appendPathComponent(endPoint.path)

        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.queryItems = endPoint.queryItems

        return urlComponents?.url
    }
}

