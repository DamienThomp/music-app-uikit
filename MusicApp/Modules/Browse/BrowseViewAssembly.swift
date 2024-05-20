//
//  BrowseViewAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

class BrowseViewAssembly: AssemblyProtocol {

    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController {

        let dataSource = BrowseDataSource()
        dataSource.resolveServices(with: serviceResolver)

        let viewModel = BrowseViewModel(dataSource: dataSource)
        let viewController = BrowseViewController()

        viewModel.delegate = viewController
        dataSource.delegate = viewModel

        return viewController
    }
}
