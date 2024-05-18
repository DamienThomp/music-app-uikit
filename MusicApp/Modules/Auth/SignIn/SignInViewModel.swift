//
//  SignInViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-16.
//

import Foundation

protocol SignInViewModelDelegate: AnyObject {

    func didSignIn()
}

class SignInViewModel {

    var dataSource: SignInDataSource?

    weak var delegate: SignInViewModelDelegate?

    init(dataSource: SignInDataSource) {
        self.dataSource = dataSource
    }

    var signInUrl: URL? { dataSource?.authUrl }

    func signIn(with code: String) async throws {

        try await dataSource?.getAccessToken(with: code)
    }
}

//MARK: - DataSource Delegate
extension SignInViewModel: SignInDataSourceDelegate {

    func didRecieveAccessToken() {

        delegate?.didSignIn()
    }
}
