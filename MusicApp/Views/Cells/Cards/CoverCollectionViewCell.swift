//
//  CoverCollectionViewCell.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-03.
//

import UIKit

class CoverCollectionViewCell: ItemViewCell, CellConfigurationProtocol {

    static let reuseIdentifier = "CoverCollectionViewCell"

    let placeHolder = UIImage(systemName: "person.and.background.dotted")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
        configureLabels()
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

        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

    }

    func configureViews() {

        contentView.addSubViews(coverImage, titleLabel, subtitleLabel)
        translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 2

        NSLayoutConstraint.activate([
            
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: padding * 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)

        ])
    }
}

#Preview(traits: .fixedLayout(width: 200, height: 250)) {

    let cellModel = BrowseItem(
        id: UUID().uuidString,
        title: "Test Name",
        subTitle: "Test Playlist Owner",
        image: URL(
            string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
        ),
        type: .playlist
    )

    let vc = CoverCollectionViewCell()
    vc.configure(with: cellModel)

    return vc
}
