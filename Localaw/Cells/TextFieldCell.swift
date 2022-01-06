//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class TextFieldCell: UITableViewCell {
    var textField: UITextField
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        textField = UITextField()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.embed(
            view: textField,
            padding: .init(top: 0, left: 20, bottom: 0, right: 0),
            height: 44)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
