//
//  ArtistDetailsAssembly.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

class ArtistDetailsAssembly: AssemblyProtocol {

    var artistId: String?

    func assemble(_ serviceResolver: ServiceLocatorProtocol, coordinator: Coordinator) -> UIViewController {

        let dataSource = ArtistDetailsDataSource()
        dataSource.resolveServices(with: serviceResolver)
        
        let viewModel = ArtistDetailsViewModel(dataSource: dataSource)
        let viewController = ArtistDetailsViewController()

        viewController.coordinator = coordinator as? ArtistDetailsCoordinator
        viewController.viewModel = viewModel
        viewController.artistId = artistId
        
        dataSource.delegate = viewModel
        viewModel.delegate = viewController

        return viewController
    }
}
