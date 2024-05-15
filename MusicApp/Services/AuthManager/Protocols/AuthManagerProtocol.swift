//
//  AuthManagerProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-14.
//

import Foundation

protocol AuthManagerProtocol {
    
    var signInUrl: URL? { get }
    var accessToken: String? { get }
    var shouldRefreshToken: Bool { get }
    var isSignedIn: Bool { get }

    func exchangeForToken(with code: String) async throws
    func refresshAccessToken() async throws
}
