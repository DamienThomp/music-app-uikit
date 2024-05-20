//
//  AuthResponse.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-02-16.
//

import Foundation

struct AuthResponse: Codable {

    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    let tokenType: String
}
