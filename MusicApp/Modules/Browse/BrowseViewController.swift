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

        configure()
        viewModel?.createInitialSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.fetchData()
    }

    private func configureViewController() {

        view.backgroundColor = .systemBackground
        navigationController?.title = "Browse"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configure() {

        configureViewController()
        configureCollectionView()
        registerCells()
        configureDataSource()
        configureDataSourceSupplement()
    }
}

//MARK: - Collection View Configuration
extension BrowseViewController {
    
    private func configureCollectionView() {

        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSectionLayout(for: sectionIndex)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        layout.configuration = config

        collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.backgroundColor = .systemBackground

        view.addSubview(collection)
    }

    private func registerCells() {
        //TODO: Register Collection View Cells
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection? {
        return nil
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
