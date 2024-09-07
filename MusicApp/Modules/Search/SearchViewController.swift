//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import UIKit

class SearchViewController: UIViewController {
    
    weak var coordinator: SearchCoordinator?
    var viewModel: SearchViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
}

extension SearchViewController: SearchViewModelDelegate {}
