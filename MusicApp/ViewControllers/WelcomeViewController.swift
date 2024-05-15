//
//  ViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

class WelcomeViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    let label = UILabel()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white

        label.text = "First View"
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .orange

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 100),
            label.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        configureButton()
    }

    func configureButton() {
        var buttonConfig = UIButton.Configuration.borderedTinted()
        buttonConfig.cornerStyle = .medium
        buttonConfig.buttonSize = .large
        buttonConfig.imagePadding = 10
        buttonConfig.baseBackgroundColor = .systemPink
        buttonConfig.baseForegroundColor = .white
        buttonConfig.image = UIImage(systemName: "house.fill")
        buttonConfig.title = "Go Home"

        button.configuration = buttonConfig
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addAction(UIAction { [weak self] _ in
            self?.coordinator?.showHomeView()
        }, for: .primaryActionTriggered)

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
}

#Preview {
    return WelcomeViewController()
}

