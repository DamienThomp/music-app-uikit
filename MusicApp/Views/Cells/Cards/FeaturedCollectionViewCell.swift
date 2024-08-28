//
//  FeaturedCollectionViewCell.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-06.
//

import UIKit

class FeaturedCollectionViewCell: ItemViewCell, CellConfigurationProtocol {

    static let reuseIdentifier = "FeaturedCollectionViewCell"

    let placeHolder = UIImage(systemName: "person.and.background.dotted")

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLabels()
        configureImageView()
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImageView() {

        coverImage.image = placeHolder
        coverImage.tintColor = .systemGray2
        coverImage.backgroundColor = .systemGray4
        coverImage.layer.cornerRadius = 5
        coverImage.clipsToBounds = true
        coverImage.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureLabels() {

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureViews() {

        contentView.addSubViews(titleLabel, subtitleLabel, coverImage)
        translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 2

        NSLayoutConstraint.activate([

            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            subtitleLabel.bottomAnchor.constraint(equalTo: coverImage.topAnchor, constant: -padding * 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding * 4),

            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor)
        ])
    }
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 250, height: 300)) {

    let cellModel = BrowseItem(
        id: "",
        title: "COWBOY SOMETHING",
        subTitle: "Bob Seeger",
        image: URL(
            string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
        ),
        type: .album
    )

    let viewController = FeaturedCollectionViewCell()
    viewController.configure(with: cellModel)

    return viewController
}
