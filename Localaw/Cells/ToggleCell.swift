//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class ToggleCell: UITableViewCell {
    var toggle: UISwitch
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        toggle = UISwitch()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = toggle
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // toggle.removeAction(, for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
