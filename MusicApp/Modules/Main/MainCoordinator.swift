//
//  MainCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

class MainCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController

    var serviceResolver: ServiceLocatorProtocol?

    init(
        _ serviceResolver: ServiceLocatorProtocol,
        _ navigationController: UINavigationController
    ) {
        self.serviceResolver = serviceResolver
        self.navigationController = navigationController
    }

    func start() {
        setupTabBar()
    }

    func setupTabBar() {
        let tabBar = MainTabBarController()
    }

}
