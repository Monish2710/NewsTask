//
//  Helper Class.swift
//  News App
//
//  Created by Monish Kumar on 30/06/23.
//

import UIKit

class Helper {
    static func makeLabel(line: Int? = nil, fontFamily: UIFont, textColor: UIColor? = nil, align: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.font = fontFamily
        label.textColor = textColor
        label.textAlignment = align ?? .natural
        label.numberOfLines = line ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false // Enable Autolayout
        return label
    }

    static func makeStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, color: UIColor? = nil, value: CGFloat? = nil) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.backgroundColor = color ?? .white
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = value ?? 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func makeImageView(cornerRadius: CGFloat? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = cornerRadius ?? 0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    static func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        let maincollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = maincollectionView.bounds.size
        maincollectionView.contentInset = .zero
        maincollectionView.showsHorizontalScrollIndicator = false
        maincollectionView.translatesAutoresizingMaskIntoConstraints = false
        return maincollectionView
    }
}

extension String {
    func formatDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd MMM yyyy"
            return outputDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
