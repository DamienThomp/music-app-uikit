//
//  AlbumTrackCollectionViewCell.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-10.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell, CellConfigurationProtocol {

    static let reuseIdentifier = "AlbumTrackCollectionViewCell"

    let trackNumber = UILabel()
    let titleLabel = UILabel()
    let innerCellDivider = UIView(frame: .zero)
    let actionButton = UIButton(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLabels()
        configureCellDivider()
        configureActionButton()
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: CellItemProtocol) {
        trackNumber.text = "\(item.subTitle)"
        titleLabel.text = item.title
    }
}

// MARK: - Configure View Layout
extension AlbumTrackCollectionViewCell {

    func configureLabels() {

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNumber.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left

        trackNumber.font = UIFont.preferredFont(forTextStyle: .body)
        trackNumber.textColor = .secondaryLabel
        trackNumber.textAlignment = .left
    }

    func configureCellDivider() {

        innerCellDivider.translatesAutoresizingMaskIntoConstraints = false
        innerCellDivider.backgroundColor = .systemGray4
    }

    func configureActionButton() {
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "ellipsis")

        actionButton.configuration = configuration
    }

    func configureCellLayout() {

        contentView.addSubViews(
            innerCellDivider,
            trackNumber,
            titleLabel,
            actionButton
        )

        NSLayoutConstraint.activate([

            innerCellDivider.heightAnchor.constraint(equalToConstant: 1),
            innerCellDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            innerCellDivider.leadingAnchor.constraint(equalTo: trackNumber.trailingAnchor, constant: 16),
            innerCellDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            trackNumber.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackNumber.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackNumber.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.40),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: trackNumber.trailingAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: actionButton.leftAnchor),

            actionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            actionButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 300, height: 60)) {
    let model = BrowseItem(
        id: UUID().uuidString,
        title: "Steed Bonnet",
        subTitle: "1",
        image: nil,
        type: .albumTrack
    )

    let viewController = AlbumTrackCollectionViewCell()
    viewController.configure(with: model)

    return viewController
}
