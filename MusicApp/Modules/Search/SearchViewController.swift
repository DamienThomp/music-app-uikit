//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-24.
//

import UIKit

enum CollectionViewError: Error {
    case unableToDequeSectionHeader
}

class SearchViewController: UIViewController {

    weak var coordinator: SearchCoordinator?
    var viewModel: SearchViewModel?

    var searchController: UISearchController?
    let resultsController: UIViewController = SearchResultsViewController()

    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, BrowseItem>

    private var collectionView: UICollectionView!

    private var dataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureSearchController()
        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
        showLoadingState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.fetchData(for: .categories)
        setNeedsUpdateContentUnavailableConfiguration()
    }

    private func configureSearchController() {

        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchBar.placeholder = "Songs, Artists, Albums, Playlists"
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.definesPresentationContext = true
        searchController?.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func configureCollectionView() {

        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: CollectionUIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }

    private func registerCells() {

        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )

        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier
        )
    }
}

// MARK: - DataSource
extension SearchViewController {

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self] _, indexPath, item in

            return self?.collectionView.configureCell(
                of: CategoryCollectionViewCell.self,
                for: item,
                at: indexPath
            )
        })
    }

    private func configureDataSourceSupplement() {
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in

            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath
            ) as? SectionHeader else {

                return nil
            }

            sectionHeader.title.text = "Categories"

            return sectionHeader
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate { }

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        guard let queryText = searchController.searchBar.text,
              !queryText.trimmingCharacters(
                in: .whitespaces
              ).isEmpty
        else {
            return
        }

        viewModel?.fetchSearchResult(with: queryText)
    }
}

extension SearchViewController: SearchViewModelDelegate {

    func reloadData(for type: SearchDataSourceType) {

        switch type {
        case .categories:
            guard let snapshot = viewModel?.categoriesSnapshot else { return }

            clearContentUnavailableState()

            dataSource?.apply(snapshot)
        case .search:
            guard let resultController = resultsController as? SearchResultsViewController,
                  let snapshot = viewModel?.searchSnapshot else { return }

            resultController.updateSnapshot(with: snapshot)
        }
    }

    func didFailLoading(with error: any Error) {

        guard let data = dataSource?.snapshot(),
              data.numberOfItems == 0 else {
            return
        }

        showErrorState(for: error)
    }
}
