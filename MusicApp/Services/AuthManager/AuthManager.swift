//
//  AuthManager.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-02-15.
//

import Foundation

enum AuthErrors: Error {
    case invalidToken
    case invalidRefreshTokenUrl
    case invalidTokenUrl
    case invalideResponse
}

final class AuthManager: AuthManagerProtocol {

    private let validResponseCodes = 200...299
    private let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    private let baseUrl: String = AuthRoutes.baseAuthUrlProd

    public var signInUrl: URL? {

        var endPoint = URL(string: "\(baseUrl)\(AuthRoutes.signIn)")

        endPoint?.append(queryItems: [
            URLQueryItem(name: "scope", value: AuthConstants.scopes)
        ])

        return endPoint
    }

    private var accessTokenUrl: URL? {
        URL(string: "\(baseUrl)\(AuthRoutes.accessToken)")
    }

    private var refreshTokenUrl: URL? {
        URL(string: "\(baseUrl)\(AuthRoutes.refreshAccess)")
    }

    public var isSignedIn: Bool {
        accessToken != nil
    }

    public var accessToken: String? {
        UserDefaults.standard.string(forKey: AuthConstants.accessTokenKey)
    }

    private var refreshToken: String? {
        UserDefaults.standard.string(forKey: AuthConstants.refreshTokenKey)
    }

    private var tokenExpiredOn: Date? {
        UserDefaults.standard.object(forKey: AuthConstants.expiresDateKey) as? Date
    }

    public var shouldRefreshToken: Bool {

        guard let tokenExpiredOn else { return false }

        let currentDate = Date()
        let timeInterval: TimeInterval = 300

        return currentDate.addingTimeInterval(timeInterval) >= tokenExpiredOn
    }

    private func buildTokenRequest(for code: String) -> URL? {

        guard var url = accessTokenUrl else { return nil }

        url.append(queryItems: [
            URLQueryItem(name: AuthConstants.queryItemCodeKey, value: code),
        ])

        return url
    }

    private func buildRefreshTokenRquest(for token: String?) -> URL? {

        guard token != nil, 
              var url = refreshTokenUrl else { return nil }

        url.append(queryItems: [
            URLQueryItem(name: AuthConstants.queryItemRefreshTokenKey, value: token),
        ])

        return url
    }

    public func exchangeForToken(with code: String) async throws {

        guard let tokenUrl = buildTokenRequest(for: code) else  {
            throw AuthErrors.invalidTokenUrl
        }


        try await getAccessToken(with: tokenUrl)
    }

    private func getAccessToken(with url: URL) async throws {

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
              validResponseCodes.contains(response.statusCode)
        else {
            print("response: \(String(describing: response))")
            throw AuthErrors.invalideResponse
        }

        let authResponse = try decoder.decode(AuthResponse.self, from: data)

        #if DEBUG
        print("authresponse: \(authResponse)")
        #endif

        cacheAccessToken(with: authResponse)
    }

    public func refresshAccessToken() async throws {

        guard let refreshTokenUrl = buildRefreshTokenRquest(for: refreshToken) else {
            throw AuthErrors.invalidRefreshTokenUrl
        }

        try await getAccessToken(with: refreshTokenUrl)
    }

    private func cacheAccessToken(with response: AuthResponse) {

        UserDefaults.standard.setValue(response.accessToken, forKey: AuthConstants.accessTokenKey)

        if let refreshToken = response.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: AuthConstants.refreshTokenKey)
        }

        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(response.expiresIn)), forKey: AuthConstants.expiresDateKey)
    }

    public func signout() {
        UserDefaults.standard.removeObject(forKey: AuthConstants.accessTokenKey)
        UserDefaults.standard.removeObject(forKey: AuthConstants.refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: AuthConstants.expiresDateKey)
    }
}
