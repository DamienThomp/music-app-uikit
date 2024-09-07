//
//  SearchViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-09-06.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {

}

class SearchViewModel {
    
    var dataSource: SearchDataSource?
    weak var delegate: SearchViewModelDelegate?

    init(dataSource: SearchDataSource) {
        self.dataSource = dataSource
    }
}

extension SearchViewModel: SearchDataSourceDelegate {

}
