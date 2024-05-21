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
        showBrowseView()
    }

    func showBrowseView() {

        let browseAssembly = BrowseViewAssembly()
        let viewController = browseAssembly.assemble(serviceResolver, coordinator: self)

        viewController.title = "Browse"
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.title = "Browse"
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: false)
    }
}
