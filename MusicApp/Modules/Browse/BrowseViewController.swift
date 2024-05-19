//
//  BrowseViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

class BrowseViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white

    }
}

#Preview {
    return BrowseViewController()
}

