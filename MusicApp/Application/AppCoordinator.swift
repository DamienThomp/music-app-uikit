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
    
    var window: UIWindow?
    var childCoordinators = [Coordinator]()
    var navigationController = UINavigationController()
    var parentCoordinator: Coordinator?

    var serviceResolver: ServiceLocatorProtocol?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {

        guard let serviceResolver = setupServices() else {
            fatalError("Could not resolve services for app start.")
        }

        resolveViewForAppstate(with: serviceResolver)
    }

    func signOut() {

        guard let serviceResolver else {
            return
        }

        navigationController.dismiss(animated: true)
        childCoordinators.removeAll()
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
            showHomeView(serviceResolver: serviceResolver, window: window)
        case .signedOut:
            showWelcomeView(serviceResolver: serviceResolver, window: window)
        }
    }

    private func resolveAppState(with serviceResolver: ServiceLocatorProtocol) -> AppState {

        guard let authManager: AuthManager = serviceResolver.resolve() else {
            return .signedOut
        }

        return authManager.isSignedIn ? .signedIn : .signedOut
    }

    private func showWelcomeView(serviceResolver: ServiceLocatorProtocol, window: UIWindow?) {

        guard let window else { return }

        let coordinator = AuthCoordinator(
            navigationController: navigationController,
            serviceResolver: serviceResolver
        )
        
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showHomeView(serviceResolver: ServiceLocatorProtocol, window: UIWindow?) {
        guard let window else {
            return
        }
        let coordinator = MainCoordinator(
            serviceResolver: serviceResolver,
            navigationController: navigationController,
            window: window,
            parentCoordinator: self
        )

        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {

    func didSignIn(with coordinator: Coordinator, serviceResolver: ServiceLocatorProtocol) {

        navigationController.popToRootViewController(animated: false)
        childCoordinators.removeAll()
        showHomeView(serviceResolver: serviceResolver, window: window)
    }
}
