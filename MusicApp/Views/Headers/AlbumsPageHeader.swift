//
//  AlbumsPageHeader.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-09.
//

import UIKit

protocol AlbumPageHeaderDelegate: AnyObject {

    func didTapArtistNameButton()
    func didTapPlayButton()
    func didTapShuffleButton()
}

class AlbumsPageHeader: UICollectionReusableView {

    static let reuseIdentifier = "AlbumsPageHeader"

    weak var delegate: AlbumPageHeaderDelegate?

    private let placeHolder = UIImage(systemName: "music.mic.circle")

    let coverImage = UIImageView()
    let titleLabel = UILabel()
    let artisNameButton = UIButton(type: .system)
    let playButton = UIButton(type: .system)
    let shuffleButton = UIButton(type: .system)

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

        titleLabel.text = model.title
        artisNameButton.setTitle(model.artisName, for: .normal)

        Task {
            await coverImage.loadImage(
                from: model.coverImage?.absoluteString ?? ""
            )
        }
    }
}

//MARK: - Configure View Layout
extension AlbumsPageHeader {

    func configureImage() {

        coverImage.image = placeHolder
        coverImage.backgroundColor = .systemPink
        coverImage.tintColor = .systemGray2
        coverImage.clipsToBounds = true
        coverImage.frame = self.bounds
        coverImage.layer.cornerRadius = 8
        coverImage.contentMode = .scaleAspectFill
        coverImage.translatesAutoresizingMaskIntoConstraints = false

        let maskLayer = CALayer()
        maskLayer.frame = coverImage.bounds

        let gradient = CAGradientLayer()
        gradient.frame = coverImage.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.65, 0.85]
        
        maskLayer.addSublayer(gradient)

        coverImage.layer.mask = maskLayer
    }
    
    func configureLabels() {

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureArtistButton() {

        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .systemGreen
        configuration.buttonSize = .medium
        configuration.titlePadding = 0
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        artisNameButton.configuration = configuration
        artisNameButton.translatesAutoresizingMaskIntoConstraints = false

        artisNameButton.addTarget(self, action: #selector(artistButtonTapped), for: .touchUpInside)
    }

    func configurePlayButtons() {

        var baseConfiguration = UIButton.Configuration.borderedTinted()
        baseConfiguration.cornerStyle = .medium
        baseConfiguration.buttonSize = .large
        baseConfiguration.titleAlignment = .center
        baseConfiguration.imagePadding = 10
        baseConfiguration.baseBackgroundColor = .systemGray

        var playButtonConfig = baseConfiguration
        playButtonConfig.image = UIImage(systemName: "play.fill")
        playButtonConfig.title = "Play"

        var shuffleButtonConfig = baseConfiguration
        shuffleButtonConfig.image = UIImage(systemName: "shuffle")
        shuffleButtonConfig.title = "Shuffle"

        playButton.configuration = playButtonConfig
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        shuffleButton.configuration = shuffleButtonConfig
        shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)

        playButton.translatesAutoresizingMaskIntoConstraints = false
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureViewLayout() {

        addSubViews(
            coverImage,
            titleLabel,
            artisNameButton,
            playButton,
            shuffleButton
        )

//        NSLayoutConstraint.activate([

//            coverImage.centerXAnchor.constraint(equalTo: centerXAnchor),
//            coverImage.topAnchor.constraint(equalTo: topAnchor),
//            coverImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
//            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor),

//            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//
//            artisNameButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            artisNameButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//
//            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            descriptionLabel.topAnchor.constraint(equalTo: artisNameButton.bottomAnchor),
//
//
//            playButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
//            playButton.widthAnchor.constraint(equalTo: shuffleButton.widthAnchor),
//            playButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
//
//            shuffleButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
//            shuffleButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8)

//        ])

        NSLayoutConstraint.activate([

            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImage.widthAnchor.constraint(equalTo: widthAnchor),
            coverImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            coverImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.80),

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
}

//MARK: - Button Actions
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

#warning("Move AlbumsPageHeaderViewModel out of view controller file")
struct AlbumsPageHeaderViewModel {

    let title: String
    let artisName: String
    let coverImage: URL?
    let genre: [String]?
    let releaseDate: String?
}

#Preview(traits: .fixedLayout(width: 390, height: 390)) {
    let model = AlbumsPageHeaderViewModel(
        title: "From Bone to Satellite From Bone to Satellite From Bone to Satellite From Bone to Satellite",
        artisName: "Tarentel",
        coverImage: URL(
            string: "https://i.scdn.co/image/ab67616d0000b273133bfea3a205d035cee306ad"
        )!,
        genre: [
            "Noise-Rock",
            "Instrumental"
        ],
        releaseDate: "1999-1"
    )
    let vc = AlbumsPageHeader()
    vc.configureView(with: model)
    return vc
}

