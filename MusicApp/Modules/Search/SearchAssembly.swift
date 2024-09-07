//
//  SearchAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-09-06.
//

import UIKit

class SearchAssembly: AssemblyProtocol {

    func assemble(_ serviceResolver: any ServiceLocatorProtocol, coordinator: any Coordinator) -> UIViewController {

        let dataSource = SearchDataSource()
        dataSource.resolveServices(with: serviceResolver)

        let viewModel = SearchViewModel(dataSource: dataSource)
        let viewController = SearchViewController()
        viewController.coordinator = coordinator as? SearchCoordinator

        dataSource.delegate = viewModel
        viewModel.delegate = viewController

        viewController.viewModel = viewModel

        return viewController
    }
}
