//
//  AvatarView.swift
//  News App
//
//  Created by Monish Kumar on 28/06/23.
//

import UIKit

class AvatarView: UIView {
    let avatarImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "avatar")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        addSubview(avatarImgView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let newHeight = frame.size.height - 8.0
        avatarImgView.bounds = CGRect(x: 0, y: 0, width: newHeight, height: newHeight)
        avatarImgView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        avatarImgView.layer.cornerRadius = newHeight / 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
