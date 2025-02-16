//
//  MainCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

class MainCoordinator: Coordinator {

    var window: UIWindow?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?

    private var serviceResolver: ServiceLocatorProtocol

    init(
        serviceResolver: ServiceLocatorProtocol,
        navigationController: UINavigationController,
        window: UIWindow,
        parentCoordinator: Coordinator
    ) {
        self.serviceResolver = serviceResolver
        self.navigationController = navigationController
        self.window = window
        self.parentCoordinator = parentCoordinator
    }

    func start() {
        setupTabBar()
    }

    func setupTabBar() {
        let tabBar = MainTabBarController()

        tabBar.viewControllers = [
            createBrowseViewController(),
            createLibraryViewController(),
            createSearchViewController()
        ]

        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

    func createBrowseViewController() -> UINavigationController {

        let browseNavigationController = UINavigationController()

        let browseCoordinator = BrowseCoordinator(
            navigationController: browseNavigationController,
            serviceResolver: serviceResolver,
            parentCoordinator: parentCoordinator
        )

        browseCoordinator.start()
        childCoordinators.append(browseCoordinator)

        return browseCoordinator.navigationController
    }

    func createSearchViewController() -> UINavigationController {

        let searchNavigationController = UINavigationController()

        let searchCoordinator = SearchCoordinator(
            navigationController: searchNavigationController,
            serviceResolver: serviceResolver
        )

        searchCoordinator.start()
        childCoordinators.append(searchCoordinator)
        
        return searchCoordinator.navigationController
    }

    func createLibraryViewController() -> UINavigationController {
        
        let libraryNavigationController = UINavigationController()

        let libraryCoordinator = LibraryCoordinator(
            navigationController: libraryNavigationController,
            serviceResolver: serviceResolver
        )

        libraryCoordinator.start()
        childCoordinators.append(libraryCoordinator)

        return libraryCoordinator.navigationController
    }
}
