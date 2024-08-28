//
//  ItemDetailsCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-22.
//

import UIKit

class ItemDetailsCoordinator: NSObject, Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?

    var serviceResolver: ServiceLocatorProtocol
    var details: BrowseItem?

    init(
        navigationController: UINavigationController,
        serviceResolver: ServiceLocatorProtocol
    ) {
        self.navigationController = navigationController
        self.serviceResolver = serviceResolver
    }

    func start() {
        let detailsAssembly = ItemDetailsAssembly()
        detailsAssembly.cellItem = details

        let viewController = detailsAssembly.assemble(serviceResolver, coordinator: self)

        navigationController.pushViewController(viewController, animated: true)
    }

    func showChildDetails(with details: BrowseItem) {
        let coordinator = ItemDetailsCoordinator(
            navigationController: navigationController,
            serviceResolver: serviceResolver
        )
        coordinator.details = details
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
