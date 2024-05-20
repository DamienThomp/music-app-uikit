//
//  BrowseViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-13.
//

import UIKit

class BrowseViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    var viewModel: BrowseViewModel?

    typealias DataSource = UICollectionViewDiffableDataSource<BrowseSections, BrowseItem>

    private var collection: UICollectionView!

    private var dataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()

        viewModel?.createInitialSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.fetchData()
    }

    private func configureViewController() {
        
        navigationController?.title = "Browse"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: - Collection View Configuration
extension BrowseViewController {
    
    private func configureCollectionView() {
        //TODO: Configure Collection View
    }

    private func registerCells() {
        //TODO: Register Collection View Cells
    }
}

//MARK: - Data Source Configuration
extension BrowseViewController {
    
    private func configureDataSource() {
        //TODO: Configure DataSource
    }

    private func configureDataSourceSupplement() {
        //TODO: Configure DataSource SupplementaryViewProvider
    }
}

//MARK: - UICollectionViewDelegate {
extension BrowseViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Handle calls to Coordinator for Routing
    }
}

//MARK: - BrowseViewModelDelegate
extension BrowseViewController: BrowseViewModelDelegate {

    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
