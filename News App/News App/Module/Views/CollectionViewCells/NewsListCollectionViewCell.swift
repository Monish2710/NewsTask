//
//  NewsListCollectionViewCell.swift
//  News App
//
//  Created by Monish Kumar on 28/06/23.
//

import SnapKit
import UIKit

class NewsListCollectionViewCell: UICollectionViewCell {
    private let imageView = Helper.makeImageView(cornerRadius: 12)
    private let titleLabel = Helper.makeLabel(line: 2, fontFamily: .systemFont(ofSize: 16, weight: .bold))
    private let contentLabel = Helper.makeLabel(line: 3, fontFamily: .systemFont(ofSize: 12, weight: .regular))
    private let dateLabel = Helper.makeLabel(line: 1, fontFamily: .systemFont(ofSize: 14, weight: .semibold), align: .right)
    private let labelStackView = Helper.makeStackView(axis: .vertical, distribution: .fillProportionally, alignment: .fill, color: .clear, value: 8)
    let tapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var callBack: (() -> Void)?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        autoresizesSubviews = true
        layer.cornerRadius = 20
        backgroundColor = .systemGray5

        addSubview(imageView)
        addSubview(labelStackView)
        addSubview(tapButton)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(contentLabel)
        labelStackView.addArrangedSubview(dateLabel)
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        setupConstraints()
    }

    func setupConstraints() {
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            labelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.0),
            labelStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8),
            labelStackView.topAnchor.constraint(equalTo: imageView.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            tapButton.topAnchor.constraint(equalTo: topAnchor),
            tapButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            tapButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            tapButton.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        tapButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }

    @objc func handleRegister(sender: UIButton) {
        callBack?()
    }

    func configue(_ model: Doc, callBack: (() -> Void)?) {
        self.callBack = callBack
        titleLabel.text = model.headline.printHeadline
        contentLabel.text = model.abstract
        imageView.image = UIImage(named: "nycTime")
        dateLabel.text = model.pub_date?.formatDate()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
