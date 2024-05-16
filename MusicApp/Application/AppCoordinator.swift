//
//  AppCoordinator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

enum AppState {

    case signedIn
    case signedOut
}

class AppCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var serviceResolver: ServiceLocatorProtocol?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        guard let serviceResolver = setupServices() else {
            #warning("handle service resolver error for appstart")
            return
        }

        resolveViewForAppstate(with: serviceResolver)
    }

    private func setupServices() -> ServiceLocatorProtocol? {

        let serviceResolver = ServiceLocator()
        self.serviceResolver = serviceResolver

        serviceResolver.register(AuthManager())
        serviceResolver.register(NetworkManager())

        guard let networkManager: NetworkManager = serviceResolver.resolve(),
              let authManager: AuthManager = serviceResolver.resolve() 
        else {
            return nil
        }

        networkManager.authManager = authManager

        return serviceResolver
    }

    private func resolveViewForAppstate(with serviceResolver: ServiceLocatorProtocol) {

        let appState = resolveAppState(with: serviceResolver)

        switch appState {
        case .signedIn:
            #warning("implement signedIn route")
        case .signedOut:
            showWelcomeView(serviceResolver: serviceResolver)
        }
    }

    private func resolveAppState(with serviceResolver: ServiceLocatorProtocol) -> AppState {

        guard let authManager: AuthManager = serviceResolver.resolve() else {
            return .signedOut
        }

        return authManager.isSignedIn ? .signedIn : .signedOut
    }

    private func showWelcomeView(serviceResolver: ServiceLocatorProtocol) {

        let coordinator = AuthCoordinator(
            navigationController: navigationController,
            serviceResolver: serviceResolver
        )

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func showHomeView() {
        #warning("implement HomeTabBarViewController")
    }
}
