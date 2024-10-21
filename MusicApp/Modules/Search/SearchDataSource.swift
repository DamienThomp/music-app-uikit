//
//  SearchDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-09-06.
//

import Foundation

enum SearchDataSourceType {
    case categories
    case search
}

enum SearchError: Error {
    case unableToResolveEndpoint
}

protocol SearchDataSourceDelegate: AnyObject {
    
    @MainActor func didLoadData(for type: SearchDataSourceType, with data: Codable)
    @MainActor func didFailLoading(with error: Error)
}

class SearchDataSource {

    private let decoder: JSONDecoder = {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }()

    private var authManager: AuthManager?
    private var networkManager: NetworkManager?

    weak var delegate: SearchDataSourceDelegate?
}

// MARK: - Data fetching
extension SearchDataSource {

    private func getEndpointForRequest(with type: SearchDataSourceType, for query: String?) -> EndpointProtocol? {

        switch type {
        case .categories:
            return BrowseEndpoint.categories()
        case .search:
            guard let query else { return nil }
            return SearchEndpoint.search(query: query)
        }
    }

    private func getResponseType(for type: SearchDataSourceType) -> Codable.Type {

        switch type {
        case .categories:
            return CategoriesResponse.self
        case .search:
            return SearchResponse.self
        }
    }

    private func executeRequest<T: Codable>(
        for endPoint: EndpointProtocol,
        of type: T.Type
    ) async throws -> T {

        if let authManager, authManager.shouldRefreshToken {
            try await authManager.refresshAccessToken()
        }

        guard let networkManager else {
            throw ServiceResolverErrors.failedToResolveService
        }

        let data = try await networkManager.request(for: endPoint)

        return try decoder.decode(T.self, from: data)
    }

    func performSearch(with query: String) {
        Task {
            do {

                let endpoint = SearchEndpoint.search(query: query)
                let data = try await executeRequest(for: endpoint, of: SearchResponse.self)

                await delegate?.didLoadData(for: .search, with: data)
            } catch {
                await delegate?.didFailLoading(with: error)
            }
        }
    }

    func fetchDisplayData(for type: SearchDataSourceType, with query: String?) {

        Task {
            do {

                guard let endpoint = getEndpointForRequest(with: type, for: query) else {
                    throw SearchError.unableToResolveEndpoint
                }

                let responseType = getResponseType(for: type)
                let data = try await executeRequest(for: endpoint, of: responseType)

                await delegate?.didLoadData(for: type, with: data)
            } catch {
                await delegate?.didFailLoading(with: error)
            }
        }
    }
}

// MARK: - Service Resolver
extension SearchDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: any ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
