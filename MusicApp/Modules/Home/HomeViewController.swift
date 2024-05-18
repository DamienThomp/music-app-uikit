//
//  HomeViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

class HomeViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white

        label.text = "Home View"
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .magenta

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 100),
            label.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

#Preview {
    return HomeViewController()
}

