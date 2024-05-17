//
//  SignInViewAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-16.
//

import UIKit

class SignInViewAssembly: AssemblyProtocol {

    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController {

        let dataSource = SignInDataSource()
        dataSource.resolveServices(with: serviceResolver)

        let viewModel = SignInViewModel(dataSource: dataSource)
        let viewController = SignInViewController()

        viewController.viewModel = viewModel
        viewController.coordinator = coordinator as? AuthCoordinator
        
        dataSource.delegate = viewModel
        viewModel.delegate = viewController

        return viewController
    }
}
