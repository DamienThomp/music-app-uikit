//
//  ServiceLocatorProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-15.
//

import Foundation

protocol ServiceLocatorProtocol {

    func register<T>(_ service: T)
    func resolve<T>() -> T?
    func key<T>(for type: T.Type) -> ObjectIdentifier
}
