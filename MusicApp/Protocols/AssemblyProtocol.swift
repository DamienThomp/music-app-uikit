//
//  AssemblyProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-16.
//

import UIKit

protocol AssemblyProtocol {
    
    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController
}
