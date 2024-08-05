//
//  ProfileViewController.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-02-15.
//

import UIKit

class ProfileViewController: UIViewController {

    weak var coordinator: Coordinator?
    var viewModel: ProfileViewModel?

    let titleLabel = UILabel(frame: .zero)
    let profileImage = UIImageView(frame: .zero)
    let userName = UILabel(frame: .zero)
    let email = UILabel(frame: .zero)
    let container = UIView(frame: .zero)

    let signOutButton: UIButton = {

        var configuration = UIButton.Configuration.borderedTinted()
        configuration.cornerStyle = .medium
        configuration.buttonSize = .medium
        configuration.titleAlignment = .center
        configuration.image = UIImage(systemName: "person.crop.square")
        configuration.imagePadding = 10
        configuration.title = "Sign Out"

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let placeHolder = UIImage(systemName: "person.and.background.dotted")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureImage()
        configureLabels()
        configureContainer()
        configureViewLayout()
        configureSignoutAction()

        viewModel?.fetchData()
    }

    func configureView(with model: ProfileResponse) {

        self.titleLabel.text = "Profile"
        self.userName.text = model.displayName
        self.email.text = model.email

        Task {
            guard let imageUrl = model.images?[0].url else { return }

            await profileImage.loadImage(from: imageUrl)
        }
    }

    func configureContainer() {

        container.clipsToBounds = true
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureImage() {

        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 125 / 2
        profileImage.contentMode = .scaleAspectFit
        profileImage.image = placeHolder
        profileImage.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureLabels() {

        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        userName.font = UIFont.preferredFont(forTextStyle: .title2)
        userName.textColor = .label
        userName.numberOfLines = 1
        userName.translatesAutoresizingMaskIntoConstraints = false

        email.font = UIFont.preferredFont(forTextStyle: .subheadline)
        email.textColor = .secondaryLabel
        email.numberOfLines = 1
        email.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureViewLayout() {

        view.addSubViews(titleLabel, container, signOutButton)

        NSLayoutConstraint.activate([

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),

            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            container.heightAnchor.constraint(equalToConstant: 125),

            signOutButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        container.addSubViews(profileImage, userName, email)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([

            profileImage.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            profileImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            profileImage.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.85),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),

            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            userName.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -20),

            email.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            email.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 4)
        ])
    }

    func configureSignoutAction() {

        let signOutUiAction = UIAction { [weak self] _ in
            self?.signOut()
        }

        signOutButton.addAction(signOutUiAction, for: .touchUpInside)
    }
}

// MARK: - Actions
extension ProfileViewController {
    
    private func signOut() {
        viewModel?.signOut()
    }
}

// MARK: - ProfileViewModelDelegate
extension ProfileViewController: ProfileViewModelDelegate {
    
    func didSignOut() {
        coordinator?.signOut()
    }

    func didFinishLoading(with data: ProfileResponse) {

        configureView(with: data)
    }
    
    func didFailLoading(with error: any Error) {
        print(error)
    }
}
