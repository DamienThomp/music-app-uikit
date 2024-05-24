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
        navigationController.delegate = self
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

//MARK: - Navigation Controller Delegate
extension ItemDetailsCoordinator: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {

        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(fromViewController)
        else {
            return
        }

        if let ItemsDetailsController = fromViewController as? ItemDetailsViewController {
            childDidFinish(ItemsDetailsController.coordinator)
        }
    }
}
