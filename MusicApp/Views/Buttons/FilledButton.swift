//
//  FilledButton.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-10-14.
//

import UIKit

class FilledButton: UIButton {

    var foreGroundColor: UIColor = .tintColor
    var buttonBackgroundColor: UIColor = .systemGray5

    required init(foregroundColor: UIColor, backgroundColor: UIColor) {
        self.buttonBackgroundColor = backgroundColor
        self.foreGroundColor = foregroundColor
        
        super.init(frame: .zero)

        configureButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton() {
        
        configuration = Configuration.filled()
        configuration?.cornerStyle = .medium
        configuration?.buttonSize = .large
        configuration?.titleAlignment = .center
        configuration?.imagePadding = 10
        configuration?.baseBackgroundColor = buttonBackgroundColor
        configuration?.baseForegroundColor = foreGroundColor

        translatesAutoresizingMaskIntoConstraints = false
    }
}
