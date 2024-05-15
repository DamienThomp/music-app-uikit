//
//  NetworkManagerProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-14.
//

import Foundation

protocol NetworkManagerProtocol {

    @discardableResult func request(for endpoint: EndpointProtocol) async throws -> Data
}
