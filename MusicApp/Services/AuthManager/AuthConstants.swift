//
//  AuthConstants.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-14.
//

import Foundation

enum AuthRoutes {

    static let baseAuthUrlProd = "https://auth-server-express.onrender.com/api/auth"
    static let baseAuthUrlDev = "http://localhost:3000/api/auth"
    static let accessToken = "/accessToken"
    static let refreshAccess = "/refreshAccess"
    static let signIn = "/signIn"
    static let callback = "/callback"
}

enum AuthConstants {

    static let apiBaseUrl = "https://api.spotify.com"
    static let apiVersion = "v1"
    static let accessTokenKey = "accessToken"
    static let refreshTokenKey = "refreshToken"
    static let expiresDateKey = "expiresDate"
    static let queryItemCodeKey = "code"
    static let queryItemRefreshTokenKey = "refresh_token"

    static var scopes: String {
        return [
            "user-modify-playback-state",
            "user-read-playback-state",
            "user-read-currently-playing",
            "user-read-private",
            "user-read-email",
            "user-top-read",
            "user-library-read",
            "user-library-modify",
            "user-follow-read",
            "playlist-read-private",
            "playlist-read-collaborative",
            "playlist-modify-private",
            "playlist-modify-public",
            "streaming"
        ].joined(separator: " ")
    }
}
