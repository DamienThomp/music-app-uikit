//
//  SearchCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-09-06.
//

import UIKit

class SearchCoordinator: NSObject, Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?

    var serviceResolver: ServiceLocatorProtocol

    init(
        navigationController: UINavigationController,
        serviceResolver: ServiceLocatorProtocol
    ) {
        self.navigationController = navigationController
        self.serviceResolver = serviceResolver
    }

    func start() {
        showSearchView()
        navigationController.delegate = self
    }

    func showSearchView() {
        let searchAssembly = SearchAssembly()

        let searchViewController = searchAssembly.assemble(serviceResolver, coordinator: self)

        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        searchViewController.navigationItem.largeTitleDisplayMode = .always

        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([searchViewController], animated: false)
    }

    func showDetails(for item: BrowseItem) {

        let coordinator = ItemDetailsCoordinator(
            navigationController: navigationController,
            serviceResolver: serviceResolver
        )

        coordinator.details = item
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension SearchCoordinator: UINavigationControllerDelegate {}
