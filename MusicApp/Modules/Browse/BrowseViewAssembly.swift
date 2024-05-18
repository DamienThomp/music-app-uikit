//
//  BrowseViewAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import UIKit

class BrowseViewAssembly: AssemblyProtocol {

    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController {

        let viewController = BrowseViewController()
        let dataSource = BrowseDataSource()
        dataSource.resolveServices(with: serviceResolver)

        let viewModel = BrowseViewModel(dataSource: dataSource)
        return viewController
    }
}
