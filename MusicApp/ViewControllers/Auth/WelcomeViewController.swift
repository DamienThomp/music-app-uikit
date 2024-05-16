//
//  ViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

class WelcomeViewController: UIViewController {

    weak var coordinator: AuthCoordinator?

    let signInButton = UIButton()
    let titleLabel = UILabel()
    let logoImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("view did load")

        view.backgroundColor = .systemBackground

        configurelabel()
        configureLogo()
        configureButton()
        configureButtonAction()
        configureLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }


    func configureLogo() {
        logoImage.image = UIImage(resource: .logoClear)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
    }

    func configurelabel() {

        titleLabel.text = "Welcome"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureButton() {

        signInButton.configuration = .borderedTinted()
        signInButton.configuration?.cornerStyle = .medium
        signInButton.configuration?.title = "Sign In"
        signInButton.configuration?.baseBackgroundColor = .systemGreen
        signInButton.configuration?.image = UIImage(systemName: "checkmark.shield")
        signInButton.configuration?.imagePlacement = .leading
        signInButton.configuration?.imagePadding = 16
        signInButton.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureButtonAction() {
        signInButton.addAction(UIAction(handler: { _ in
            print("navigate to auth screen")
        }), for: .primaryActionTriggered)
    }

    func configureLayout() {

        view.addSubViews(
            titleLabel,
            logoImage,
            signInButton
        )

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

#Preview {
    WelcomeViewController()
}
