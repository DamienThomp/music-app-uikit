//
//  ServiceLocator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-15.
//

import Foundation

enum ServiceResolverErrors: Error {

    case failedToResolveService
}

final class ServiceLocator: ServiceLocatorProtocol {

    internal var services: [ObjectIdentifier: Any] = [:]

    func register<T>(_ service: T) {
        services[key(for: T.self)] = service
    }
    
    func resolve<T>() -> T? {
        return services[key(for: T.self)] as? T
    }
    
    func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}
