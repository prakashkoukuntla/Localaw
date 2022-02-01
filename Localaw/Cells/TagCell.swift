//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UICollectionViewCell {
    var label: UILabel
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.textColor = .white
                contentView.backgroundColor = .purple
                contentView.layer.borderColor = UIColor.clear.cgColor
                contentView.layer.borderWidth = 1
                contentView.layer.cornerRadius = 4
                contentView.layer.cornerCurve = .continuous
                contentView.layer.masksToBounds = true
            } else {
                label.textColor = .black
                contentView.backgroundColor = .white
                contentView.layer.borderColor = UIColor.black.cgColor
                contentView.layer.borderWidth = 1
                contentView.layer.cornerRadius = 4
                contentView.layer.cornerCurve = .continuous
                contentView.layer.masksToBounds = true
            }
        }
    }
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame: frame)
        contentView.embed(view: label, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.backgroundColor = .white
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
//        contentView.layer.cornerRadius = 4
//        contentView.layer.cornerCurve = .continuous
//        contentView.layer.masksToBounds = true
        isSelected = false

             NSLayoutConstraint.activate([
                contentView.leftAnchor.constraint(equalTo: leftAnchor),
                 contentView.rightAnchor.constraint(equalTo: rightAnchor),
                 contentView.topAnchor.constraint(equalTo: topAnchor),
                 contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
             ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
