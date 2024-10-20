//
//  ProfileViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-08-04.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {

    @MainActor func didFinishLoading(with data: ProfileResponse)
    @MainActor func didFailLoading(with error: Error)
    @MainActor func didSignOut()
}

class ProfileViewModel {

    weak var delegate: ProfileViewModelDelegate?

    var dataSource: ProfileDataSource?

    init(dataSource: ProfileDataSource) {
        self.dataSource = dataSource
    }

    func fetchData() {
        dataSource?.fetchDisplayData()
    }

    func signOut() {
        dataSource?.signOut()
    }
}

extension ProfileViewModel: ProfileDataSourceDelegate {
    
    func didSignOut() {
        delegate?.didSignOut()
    }
    
    func didFinishLoading(with data: ProfileResponse) {
        delegate?.didFinishLoading(with: data)
    }
    
    func didFailLoading(with error: Error) {
        delegate?.didFailLoading(with: error)
    }
}
