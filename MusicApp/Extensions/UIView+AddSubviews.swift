//
//  UIView+AddSubviews.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-15.
//

import UIKit

extension UIView {

    func addSubViews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
