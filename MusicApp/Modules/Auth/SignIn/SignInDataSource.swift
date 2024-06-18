//
//  SignInDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-16.
//

import Foundation

enum SignInError: Error {

    case failedToLoadService
}

protocol SignInDataSourceDelegate: AnyObject {

    func didRecieveAccessToken()
}

class SignInDataSource {

    private var authManager: AuthManager?

    weak var delegate: SignInDataSourceDelegate?

    var authUrl: URL? { authManager?.signInUrl }

    func getAccessToken(with code: String) async throws {

        guard let authManager = authManager else {
            throw SignInError.failedToLoadService
        }

        try await authManager.exchangeForToken(with: code)

        delegate?.didRecieveAccessToken()
    }
}

// MARK: - Service Resolver
extension SignInDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {
        
        authManager = serviceResolver.resolve()
    }
}
