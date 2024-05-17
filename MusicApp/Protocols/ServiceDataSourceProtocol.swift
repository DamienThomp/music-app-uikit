//
//  ServiceDataSourceProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-16.
//

import Foundation


protocol ServiceDataSourceProtocol {

    func resolveServices(with serviceResolver: ServiceLocatorProtocol)
}
