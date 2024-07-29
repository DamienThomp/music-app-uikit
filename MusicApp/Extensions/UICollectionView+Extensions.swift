//
//  UICollectionView+Extensions.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-07-28.
//

import UIKit

extension UICollectionView {

    func configureCell<T: CellConfigurationProtocol>(
        of cellType: T.Type,
        for item: CellItemProtocol,
        at indexPath: IndexPath
    ) -> T {

        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("unable to dequeue cell: \(cellType)")
        }

        cell.configure(with: item)

        return cell
    }
}
