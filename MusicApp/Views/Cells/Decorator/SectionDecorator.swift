//
//  SectionDecorator.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-23.
//

import UIKit

class SectionDecorator: UICollectionReusableView {

    static var reuseIdentifier = "SectionBackground"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDecorator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDecorator() {
        backgroundColor = .systemBackground

        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = [UIColor.systemBackground.cgColor, UIColor.systemGray6.cgColor]

        self.layer.insertSublayer(gradient, at: 0)

    }
}
