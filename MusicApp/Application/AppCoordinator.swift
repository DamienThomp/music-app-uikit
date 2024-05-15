//
//  AppCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

class AppCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.navigationBar.prefersLargeTitles = true
        showWelcomeView()
    }

    func showWelcomeView() {
        let viewController = WelcomeViewController()
        viewController.title = "Welcome"
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func showHomeView() {
        let viewController = HomeViewController()
        viewController.title = "Home"
        navigationController.pushViewController(viewController, animated: true)
    }
}
