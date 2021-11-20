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
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
