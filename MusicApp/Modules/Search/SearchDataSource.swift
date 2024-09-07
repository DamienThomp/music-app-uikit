//
//  SearchDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-09-06.
//

import Foundation

protocol SearchDataSourceDelegate: AnyObject {}

class SearchDataSource {

    private var authManager: AuthManager?
    private var networkManager: NetworkManager?

    weak var delegate: SearchDataSourceDelegate?
}

// MARK: - Service Resolver
extension SearchDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: any ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkManager = serviceResolver.resolve()
    }
}
