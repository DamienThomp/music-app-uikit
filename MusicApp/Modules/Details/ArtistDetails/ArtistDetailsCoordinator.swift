//
//  ArtistDetailsCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

class ArtistDetailsCoordinator: NSObject, Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: (any Coordinator)?

    var serviceResolver: ServiceLocatorProtocol
    var artistId: String?

    init(
        navigationController: UINavigationController,
        serviceResolver: ServiceLocatorProtocol
    ) {
        self.navigationController = navigationController
        self.serviceResolver = serviceResolver
    }

    func start() {

        let artistDetailsAssembly = ArtistDetailsAssembly()
        artistDetailsAssembly.artistId = artistId

        let viewController = artistDetailsAssembly.assemble(serviceResolver, coordinator: self)

        navigationController.pushViewController(viewController, animated: true)
    }
}
