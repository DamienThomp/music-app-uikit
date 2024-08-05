//
//  LibraryCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import UIKit

class LibraryCoordinator: NSObject, Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?

    var serviceResolver: ServiceLocatorProtocol

    init(
        navigationController: UINavigationController,
        serviceResolver: ServiceLocatorProtocol
    ) {
        self.navigationController = navigationController
        self.serviceResolver = serviceResolver
    }

    func start() {
        navigationController.delegate = self
        showLibrary()
    }

    func showLibrary() {

        let libraryAssembly = LibraryAssembly()
        let viewController = libraryAssembly.assemble(serviceResolver, coordinator: self)

        viewController.title = "Library"
        viewController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 2)
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([viewController], animated: false)
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

extension LibraryCoordinator: UINavigationControllerDelegate {

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

        if let itemsDetailsController = fromViewController as? ItemDetailsViewController {
            childDidFinish(itemsDetailsController.coordinator)
        }
    }
}
