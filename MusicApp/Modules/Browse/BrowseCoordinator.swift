//
//  BrowseCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

class BrowseCoordinator: NSObject, Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?

    private var serviceResolver: ServiceLocatorProtocol

    init(
        navigationController: UINavigationController,
        serviceResolver: ServiceLocatorProtocol,
        parentCoordinator: Coordinator?
    ) {

        self.navigationController = navigationController
        self.serviceResolver = serviceResolver
        self.parentCoordinator = parentCoordinator
    }

    func start() {
        showBrowseView()
        navigationController.delegate = self
    }

    func showBrowseView() {

        let browseAssembly = BrowseViewAssembly()
        let viewController = browseAssembly.assemble(serviceResolver, coordinator: self)

        viewController.title = "Browse"
        viewController.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "house"), tag: 0)
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

    func presentProfile() {

        let profileAssembly = ProfileAssembly()
        let viewController = profileAssembly.assemble(serviceResolver, coordinator: self)
        
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .pageSheet
        nav.sheetPresentationController?.detents = [.medium()]
        navigationController.present(nav, animated: true)
    }

    func signOut() {
        parentCoordinator?.signOut()
    }
}

// MARK: - Navigation Controller Delegate
extension BrowseCoordinator: UINavigationControllerDelegate {

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
