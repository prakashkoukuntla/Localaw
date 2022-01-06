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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
