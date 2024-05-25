//
//  LibraryAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import UIKit

class LibraryAssembly: AssemblyProtocol {

    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController {

        let dataSource = LibraryDataSource()
        dataSource.resolveServices(with: serviceResolver)

        let viewModel = LibraryViewModel(dataSource: dataSource)
        let viewController = LibraryViewController()

        viewController.viewModel = viewModel
        viewController.coordinator = coordinator as? LibraryCoordinator

        viewModel.delegate = viewController
        dataSource.delegate = viewModel

        return viewController
    }
}
