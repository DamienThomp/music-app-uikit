//
//  BannerCollectionViewCell.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-12-19.
//

import UIKit

class BannerCollectionViewCell: ItemViewCell, CellConfigurationProtocol {

    static let reuseIdentifier: String = "BannerCollectionViewCell"

    let placeHolder = UIImage(systemName: "person.and.background.dotted")

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureImageView()
        configureLabel()
        configureViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

       // configureImageMask()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImageMask() {

        let maskLayer = CALayer()
        maskLayer.frame = coverImage.bounds

        let gradient = CAGradientLayer()
        gradient.frame = coverImage.bounds

        let color = UIColor.black

        gradient.colors = [
            color.withAlphaComponent(0.0).cgColor,
            color.cgColor,
            color.cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]

        gradient.locations = [
            0,
            0.30,
            0.45,
            1
        ]

        maskLayer.addSublayer(gradient)

        coverImage.layer.mask = maskLayer
    }
    
    private func configureImageView() {

        coverImage.image = placeHolder
        coverImage.clipsToBounds = true
        coverImage.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLabel() {

        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureViews() {

        contentView.addSubViews(coverImage, titleLabel)
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22)
        ])
    }
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 200, height: 250)) {

    let cellModel = BrowseItem(
        id: UUID().uuidString,
        title: "Test Name",
        subTitle: "Test Playlist Owner",
        image: URL(
            string: "https://i.scdn.co/image/66bf46ec1bfc2c72b97986f84af1a69f07531329"
        ),
        type: .playlist
    )

    let viewController = BannerCollectionViewCell()
    viewController.configure(with: cellModel)

    return viewController
}
