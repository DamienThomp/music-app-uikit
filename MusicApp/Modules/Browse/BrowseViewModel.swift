//
//  BrowseViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-18.
//

import Foundation

protocol BrowseViewModelDelegate: AnyObject {}

class BrowseViewModel {
    
    weak var delegate: BrowseViewModelDelegate?
    var dataSource: BrowseDataSource?

    init(dataSource: BrowseDataSource) {
        self.dataSource = dataSource
    }
}
