//
//  ArtistDetailsViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-18.
//

import UIKit

class ArtistDetailsViewController: UIViewController {

    weak var coordinator: ArtistDetailsCoordinator?
    var viewModel: ArtistDetailsViewModel?

    var artistId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        title = "Artist Page"
    }
}

extension ArtistDetailsViewController: ArtistDetailViewModelDelegate {
    
    func reloadData() {
        // todo
    }
    
    func didFailLoading(with error: any Error) {
        // todo
    }
    
    func didUpdateSavedStatus() {
        // todo
    }
    
    func didFailToSaveItem() {
        // todo
    }
}
