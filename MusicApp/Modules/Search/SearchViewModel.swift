//
//  SearchViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-09-06.
//

import UIKit

enum SearchSection {
    case main
}

protocol SearchViewModelDelegate: AnyObject {
    @MainActor func reloadData(for type: SearchDataSourceType)
    @MainActor func didFailLoading(with error: Error)
}

class SearchViewModel {

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SearchSection, BrowseItem>

    private(set) var categoriesSnapshot: DataSourceSnapshot?
    private(set) var searchSnapshot: DataSourceSnapshot?

    var dataSource: SearchDataSource?
    weak var delegate: SearchViewModelDelegate?
    
    init(dataSource: SearchDataSource) {
        self.dataSource = dataSource
    }

    func fetchData(for type: SearchDataSourceType, with query: String?) {
        dataSource?.fetchDisplayData(for: type, with: query)
    }

    func updateCategoriesSnapshot(with data: Codable) {
        guard let data = data as? CategoriesResponse else { return }

        let viewModel = data.categories.items.compactMap(BrowseItem.init)

        categoriesSnapshot = DataSourceSnapshot()

        categoriesSnapshot?.appendSections([.main])
        categoriesSnapshot?.appendItems(viewModel, toSection: .main)
    }
}

extension SearchViewModel: SearchDataSourceDelegate {

    func didLoadData(for type: SearchDataSourceType, with data: Codable) {
        switch type {

        case .categories:
            updateCategoriesSnapshot(with: data)
            delegate?.reloadData(for: type)
        case .search:
            print("todo")
        }
    }

    
    func didFailLoading(with error: Error) {
        delegate?.didFailLoading(with: error)
    }
}
