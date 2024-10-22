//
//  AlbumsPageHeader.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-09.
//

import UIKit

#warning("Move AlbumsPageHeaderViewModel out of view controller file")
struct AlbumsPageHeaderViewModel {

    let title: String
    let artisName: String
    let coverImage: URL?
    let genre: [String]?
    let type: ItemType
}

protocol AlbumPageHeaderDelegate: AnyObject {

    func didTapArtistNameButton()
    func didTapPlayButton()
    func didTapShuffleButton()
}

class AlbumsPageHeader: UICollectionReusableView {

    static let reuseIdentifier = "AlbumsPageHeader"

    weak var delegate: AlbumPageHeaderDelegate?

    let coverImage = UIImageView()
    let titleLabel = UILabel()
    let artisNameButton = UIButton(type: .system)
    let playButton = FilledButton(foregroundColor: .tintColor, backgroundColor: .systemGray5)
    let shuffleButton = FilledButton(foregroundColor: .tintColor, backgroundColor: .systemGray5)

    var itemType: ItemType = .album

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        configureImage()
        configureLabels()
        configureArtistButton()
        configurePlayButtons()
        configureViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView(with model: AlbumsPageHeaderViewModel) {
        itemType = model.type
        
        titleLabel.text = model.title
        artisNameButton.setTitle(model.artisName, for: .normal)
        configureImageLayout(for: model.type)

        Task {
            await coverImage.loadImage(
                from: model.coverImage?.absoluteString ?? ""
            )
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if itemType == .album {
            configureImageMask()
        }
    }
}

// MARK: - Configure View Layout
extension AlbumsPageHeader {

    func configureImage() {
        coverImage.contentMode = .scaleAspectFill
        coverImage.translatesAutoresizingMaskIntoConstraints = false
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

    func configureLabels() {

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureArtistButton() {

        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .tintColor
        configuration.buttonSize = .large
        configuration.titlePadding = 0
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        artisNameButton.configuration = configuration
        artisNameButton.translatesAutoresizingMaskIntoConstraints = false

        artisNameButton.addTarget(self, action: #selector(artistButtonTapped), for: .touchUpInside)
    }

    func configurePlayButtons() {

        playButton.configuration?.title = "Play"
        playButton.configuration?.image = UIImage(systemName: "play.fill")
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        shuffleButton.configuration?.title = "Shuffle"
        shuffleButton.configuration?.image = UIImage(systemName: "shuffle")
        shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
    }

    func configureViewLayout() {

        addSubViews(
            coverImage,
            titleLabel,
            artisNameButton,
            playButton,
            shuffleButton
        )

        NSLayoutConstraint.activate([

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: artisNameButton.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            artisNameButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            artisNameButton.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -16),

            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            playButton.widthAnchor.constraint(equalTo: shuffleButton.widthAnchor),
            playButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            shuffleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            shuffleButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8)
        ])
    }

    private func configureImageLayout(for type: ItemType) {

        if type == .playlist {

            coverImage.clipsToBounds = true
            coverImage.frame = self.bounds
            coverImage.layer.cornerRadius = 8

            NSLayoutConstraint.activate([
                coverImage.centerXAnchor.constraint(equalTo: centerXAnchor),
                coverImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -24),
                coverImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
                coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor)
            ])
        }

        if type == .album {
            
            NSLayoutConstraint.activate([
                coverImage.topAnchor.constraint(equalTo: topAnchor),
                coverImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                coverImage.trailingAnchor.constraint(equalTo: trailingAnchor),
                coverImage.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}

// MARK: - Button Actions
extension AlbumsPageHeader {

    @objc func artistButtonTapped() {
        delegate?.didTapArtistNameButton()
    }

    @objc func playButtonTapped() {
        delegate?.didTapPlayButton()
    }

    @objc func shuffleButtonTapped() {
        delegate?.didTapShuffleButton()
    }
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 390, height: 390)) {
    let model = AlbumsPageHeaderViewModel(
        title: "From Bone to Satellite",
        artisName: "Tarentel",
        coverImage: URL(
            string: "https://i.scdn.co/image/ab67616d0000b273133bfea3a205d035cee306ad"
        )!,
        genre: [
            "Noise-Rock",
            "Instrumental"
        ],
        type: .album
    )
    let viewController = AlbumsPageHeader()
    viewController.configureView(with: model)
    return viewController
}
