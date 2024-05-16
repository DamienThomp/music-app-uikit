//
//  AuthCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-15.
//

import UIKit

class AuthCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var serviceResolver: ServiceLocatorProtocol

    init(
        navigationController: UINavigationController,
        serviceResolver:  ServiceLocatorProtocol
    ) {
        self.navigationController = navigationController
        self.serviceResolver = serviceResolver
    }

    func start() {
        let viewController = WelcomeViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func showSignInView() {
        print("show sign in view")
    }

}
