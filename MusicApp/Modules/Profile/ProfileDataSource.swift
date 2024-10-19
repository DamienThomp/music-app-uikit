//
//  ProfileDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-08-04.
//

import Foundation

protocol ProfileDataSourceDelegate: AnyObject {

    @MainActor func didFinishLoading(with data: ProfileResponse)
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didSignOut()
}

class ProfileDataSource {
    
    private let decoder: JSONDecoder = {

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }()

    private var authManager: AuthManager?
    private var networkManager: NetworkManager?

    weak var delegate: ProfileDataSourceDelegate?
}

// MARK: - Data Fetching
extension ProfileDataSource {

    private func fetchProfile(with endPoint: EndpointProtocol) async throws -> ProfileResponse {
        
        guard let networkManager else { throw ServiceResolverErrors.failedToResolveService }

        let data = try await networkManager.request(for: endPoint)

        return try decoder.decode(ProfileResponse.self, from: data)
    }

    func signOut() {
        
        guard let authManager else { return }

        authManager.signout()

        Task {
            await delegate?.didSignOut()
        }
    }

    func fetchDisplayData() { 
        Task {
            do {
                if let authManager, authManager.shouldRefreshToken {
                    try await authManager.refresshAccessToken()
                }

                let endpoint = ProfileEndpoint.user
                let response = try await fetchProfile(with: endpoint)

                await delegate?.didFinishLoading(with: response)
            } catch {
                await delegate?.didFailLoading(with: error)
            }
        }
    }
}
// MARK: - Service Resolver
extension ProfileDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
