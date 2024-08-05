//
//  ProfileAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-08-04.
//

import UIKit

class ProfileAssembly: AssemblyProtocol {

    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController {

        let dataSource = ProfileDataSource()
        dataSource.resolveServices(with: serviceResolver)

        let viewModel = ProfileViewModel(dataSource: dataSource)
        let viewController = ProfileViewController()

        viewController.viewModel = viewModel
        viewController.coordinator = coordinator

        viewModel.delegate = viewController
        dataSource.delegate = viewModel

        return viewController
    }
}
