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

    func showErrorState(for error: Error, _ retryFunction: @escaping () -> Void) {

        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "exclamationmark.circle.fill")
        config.text = "Something went wrong."
        config.secondaryText = "\(error)"

        var retryButtonConfig = UIButton.Configuration.borderedProminent()
        retryButtonConfig.title = "Retry"
        retryButtonConfig.image = UIImage(systemName: "arrow.clockwise.circle.fill")
        retryButtonConfig.imagePadding = 16
        config.button = retryButtonConfig

        config.buttonProperties.primaryAction = UIAction { _ in
            retryFunction()
        }

        contentUnavailableConfiguration = config
    }

    func clearContentUnavailableState() {

        contentUnavailableConfiguration = nil
    }
}
