//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UICollectionViewCell {
    var label: UILabel
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame: frame)
        contentView.embed(view: label)
        contentView.translatesAutoresizingMaskIntoConstraints = false
             
             NSLayoutConstraint.activate([
                 contentView.leftAnchor.constraint(equalTo: leftAnchor),
                 contentView.rightAnchor.constraint(equalTo: rightAnchor),
                 contentView.topAnchor.constraint(equalTo: topAnchor),
                 contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
             ])
        //contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.widthAnchor.constraint(equalToConstant: 10),
//            contentView.heightAnchor.constraint(equalToConstant: 50)
//        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
