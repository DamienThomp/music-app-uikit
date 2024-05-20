//
//  CategoryCardCollectionViewCell.swift
//  SpotifyCloneUIkit
//
//  Created by Damien L Thompson on 2024-04-07.
//

import UIKit

class CategoryCardCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "CategoryCardCollectionViewCel"

    let coverImage = UIImageView(frame: .zero)
    let titleLabel = UILabel()
    let container = UIView(frame: .zero)

    private var task: Task<(), Never>?

    private let placeHolder = UIImage(systemName: "music.mic.circle")

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureImage()
        configureLabel()
        configureContainer()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        coverImage.image = placeHolder
        titleLabel.text = nil
    }

    func configureCell(with model: CellItemProtocol) {
        titleLabel.text = model.title
        loadImage(from: model.image)
    }

    func loadImage(from url: URL?) {

//        guard let url = url?.absoluteString else {
//            print("can't get url")
//            return
//        }
//
//        task = Task {
//            await coverImage.loadImage(from: url)
//        }
    }

    func configureImage() {

        coverImage.image = placeHolder
        coverImage.tintColor = .systemGray2
        coverImage.clipsToBounds = true
        coverImage.contentMode = .scaleToFill
        coverImage.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureLabel() {

        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

    }

    func configureContainer() {
        self.addSubview(container)

        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor),
            container.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    func configureLayout() {

        container.addSubViews(coverImage, titleLabel)

        NSLayoutConstraint.activate([
            coverImage.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            coverImage.heightAnchor.constraint(equalTo: container.heightAnchor),
            coverImage.widthAnchor.constraint(equalTo: container.widthAnchor),

            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}


#Preview(traits: .fixedLayout(width: 360, height: 360)) {
    let model = BrowseItem(id: "", title: "Some Category", subTitle: "", image: URL(
        string: "https://t.scdn.co/media/derived/pop-274x274_447148649685019f5e2a03a39e78ba52_0_0_274_274.jpg"
    ))

    let vc = CategoryCardCollectionViewCell()
    vc.configureCell(with: model)

    return vc
}
