//
//  CellItemProtocol.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-19.
//

import Foundation

protocol CellItemProtocol {

    var id: String { get }
    var title: String { get }
    var subTitle: String { get }
    var image: URL? { get }
}
