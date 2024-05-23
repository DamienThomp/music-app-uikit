//
//  ItemDetailsAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-22.
//

import UIKit

class ItemDetailsAssembly: AssemblyProtocol {

    var cellItem: BrowseItem?

    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController {

        let dataSource = ItemDetailsDataSource()
        dataSource.resolveServices(with: serviceResolver)

        let viewModel = ItemDetailsViewModel(dataSource: dataSource)
        let viewController = ItemDetailsViewController()
        
        viewController.coordinator = coordinator as? ItemDetailsCoordinator
        viewController.viewModel = viewModel
        viewController.cellItemData = cellItem

        dataSource.delegate = viewModel
        viewModel.delegate = viewController

        return viewController
    }
}
