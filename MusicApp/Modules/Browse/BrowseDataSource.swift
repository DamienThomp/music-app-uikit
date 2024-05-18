//
//  BrowseDataSource.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import Foundation

protocol BrowseDataSourceDelegate: AnyObject {}

class BrowseDataSource {
    
    private var authManager: AuthManager?
    private var networkMnager: NetworkManager?

    weak var delegate: BrowseDataSourceDelegate?
}

//MARK: - Service Resolver
extension BrowseDataSource: ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol) {

        authManager = serviceResolver.resolve()
        networkMnager = serviceResolver.resolve()
    }
}
