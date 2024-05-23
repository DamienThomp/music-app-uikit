//
//  PlaylistTrackCollectionViewCell.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-03.
//

import UIKit

class PlaylistTrackCollectionViewCell: UICollectionViewCell, CellConfigurationProtocol {

    static let reuseIdentifier = "PlaylistTrackCollectionViewCell"

    let coverImage = AsyncImageView(frame: .zero)
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let actionButton = UIButton(frame: .zero)

    private var task: Task<(), Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureImageView()
        configureActionButton()
        configureLabels()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {

        coverImage.cancelImageLoad()
        coverImage.image = UIImage()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    func configureImageView() {

        coverImage.image = UIImage(systemName: "person.and.background.dotted")
        coverImage.contentMode = .scaleAspectFit
        coverImage.layer.cornerRadius = 5
        coverImage.clipsToBounds = true
        coverImage.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureActionButton() {

        actionButton.translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "ellipsis")

        actionButton.configuration = configuration
    }

    func configureLabels() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(with item: CellItemProtocol) {

        titleLabel.text = item.title
        subtitleLabel.text = item.subTitle
        coverImage.executeLoad(from: item.image)
    }

    func configureViews() {

        contentView.addSubViews(coverImage, titleLabel, subtitleLabel, actionButton)
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([

            coverImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            coverImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            coverImage.widthAnchor.constraint(equalTo: coverImage.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -8),

            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            subtitleLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -8),

            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            actionButton.widthAnchor.constraint(equalToConstant: 40)

        ])
    }

}

#Preview(traits: .fixedLayout(width: 300, height: 50)) {

    let model = BrowseItem(
        id: UUID().uuidString,
        title: "Song Title with a really long title so it breaks to another line",
        subTitle: "Some Band",
        image: URL(
            string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
        ),
        type: .playlistTrack
    )

    let vc = PlaylistTrackCollectionViewCell()
    vc.configure(with: model)

    return vc
}
