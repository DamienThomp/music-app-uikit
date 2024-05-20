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

        navigationController?.navigationBar.barTintColor = .white

        viewModel?.createInitialSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.fetchData()
    }
}

extension BrowseViewController: BrowseViewModelDelegate {

    func reloadData() {

        guard let snapshot = viewModel?.snapshot else { return }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
