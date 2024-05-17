//
//  SignInViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-16.
//

import Foundation

protocol SignInViewModelProtocol: AnyObject {
    func didSignIn()
}

class SignInViewModel {

    var dataSource: SignInDataSource?
    weak var delegate: SignInViewModelProtocol?

    init(dataSource: SignInDataSource) {
        self.dataSource = dataSource
    }

    func getSignInUrl() -> URL? {
        return dataSource?.authUrl
    }

    func signIn(with code: String) async throws {
        print("code: \(code)")
        try await dataSource?.getAccessToken(with: code)
    }
}

//MARK: - DataSource Delegate
extension SignInViewModel: SignInDataSourceProtocol {

    func didRecieveAccessToken() {
        delegate?.didSignIn()
    }
}
