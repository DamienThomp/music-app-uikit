//
//  CellConfigurationProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-20.
//

import Foundation

protocol CellConfigurationProtocol {

    static var reuseIdentifier: String { get }

    func configure(with item: CellItemProtocol)
}
