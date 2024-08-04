//
//  UIViewController+Extensions.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-08-03.
//

import UIKit

extension UIViewController {
    
    func showLoadingState() {

        var config = UIContentUnavailableConfiguration.loading()
        config.text = "Loading Please wait..."
        config.textProperties.font = .boldSystemFont(ofSize: 18)
        config.imageToTextPadding = 12

        contentUnavailableConfiguration = config
    }

    func showErrorState(for error: Error) {

        // TODO: - handle messages for loading errors
        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "exclamationmark.circle.fill")
        config.text = "Something went wrong."
        config.secondaryText = "Please try again later."

        contentUnavailableConfiguration = config
    }

    func clearContentUnavailableState() {

        contentUnavailableConfiguration = nil
    }
}
