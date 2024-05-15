//
//  NetworkManagerErrors.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-02-19.
//

import Foundation

enum NetworkManagerErrors: String, Error {
    case networkError = "Unable to complete your request. Please check your connection."
    case invalidUrl = "Invalid URL"
    case invalidRequest = "Invalid request, please try again."
    case invalidResponse = "Invalid response, please try again"
}
