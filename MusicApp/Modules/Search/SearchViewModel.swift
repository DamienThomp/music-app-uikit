//
//  SearchViewModel.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-09-06.
//

import UIKit
import Combine

enum SearchSection {
    case main
}

enum SearchResultSection: Hashable, CaseIterable {

    case albums
    case artists
    case tracks

    var title: String {

        switch self {
        case .albums:
            "Albums"
        case .artists:
            "Artists"
        case .tracks:
            "Tracks"
        }
    }
}

protocol SearchViewModelDelegate: AnyObject {
    @MainActor func reloadData(for type: SearchDataSourceType)
    @MainActor func didFailLoading(with error: Error)
}

class SearchViewModel {

    private var userSearchInputSubject = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()

    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SearchSection, BrowseItem>
    typealias SearchSourceSnapshot = NSDiffableDataSourceSnapshot<SearchResultSection, BrowseItem>

    private(set) var categoriesSnapshot: DataSourceSnapshot?
    private(set) var searchSnapshot: SearchSourceSnapshot?

    var dataSource: SearchDataSource?
    weak var delegate: SearchViewModelDelegate?

    init(dataSource: SearchDataSource) {
        self.dataSource = dataSource
        configureSearch()
    }

    func fetchData(for type: SearchDataSourceType) {
        dataSource?.fetchDisplayData(for: type, with: nil)
    }

    func fetchSearchResult(with query: String) {
        userSearchInputSubject.send(query)
    }

    private func configureSearch() {
        userSearchInputSubject
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] searchInput in
                guard let query = searchInput else { return }
                self?.dataSource?.performSearch(with: query)
            }
            .store(in: &cancellables)
    }

    private func updateCategoriesSnapshot(with data: Codable) {

        guard let data = data as? CategoriesResponse else { return }

        let viewModel = data.categories.items.compactMap(BrowseItem.init)

        categoriesSnapshot = DataSourceSnapshot()

        categoriesSnapshot?.appendSections([.main])
        categoriesSnapshot?.appendItems(viewModel, toSection: .main)
    }

    private func configureViewModel(for section: SearchResultSection, with data: SearchResponse) -> [BrowseItem]? {

        switch section {
        case .albums:
            return data.albums.items.compactMap(BrowseItem.init)
        case .artists:
            return data.artists.items.compactMap(BrowseItem.init)
        case .tracks:
            return data.tracks.items.compactMap(BrowseItem.init)
        }
    }

    private func updateSearchSnapshot(with data: SearchResponse) {

        let sections = SearchResultSection.allCases

        searchSnapshot = SearchSourceSnapshot()
        searchSnapshot?.appendSections(sections)

        for section in sections {
            if let items = configureViewModel(for: section, with: data) {
                searchSnapshot?.appendItems(items, toSection: section)
            }
        }
    }
}

extension SearchViewModel: SearchDataSourceDelegate {

    func didLoadData(for type: SearchDataSourceType, with data: Codable) {

        switch type {
        case .categories:
            updateCategoriesSnapshot(with: data)
        case .search:
            guard let data = data as? SearchResponse else { return }
            updateSearchSnapshot(with: data)
        }

        delegate?.reloadData(for: type)
    }

    func didFailLoading(with error: Error) {
        delegate?.didFailLoading(with: error)
    }
}
