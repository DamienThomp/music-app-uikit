//
//  BrowseCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

class BrowseCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var serviceResolver: ServiceLocatorProtocol

    init(
        navigationController: UINavigationController,
        serviceResolver: ServiceLocatorProtocol
    ) {

        self.navigationController = navigationController
        self.serviceResolver = serviceResolver
    }

    func start() {

    }
}
