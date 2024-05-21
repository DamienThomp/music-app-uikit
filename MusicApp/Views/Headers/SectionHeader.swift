//
//  SectionHeader.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-04-06.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"

    let title = UILabel()
    let subtitle = UILabel()
    var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabels()
        configureStackView()
        configureView()
    }

    func configureLabels() {

        title.textColor = .label
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        subtitle.textColor = .secondaryLabel
    }


    func configureStackView() {

        stackView = UIStackView(arrangedSubviews: [title, subtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
    }


    func configureView() {

        addSubview(stackView)

        NSLayoutConstraint.activate([

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            title.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            subtitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let vc = SectionHeader()
    vc.title.text = "New Release"
    vc.subtitle.text = "Todays top albums"

    return vc
}
