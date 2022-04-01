//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class BillCell: UITableViewCell {
    
    var bookmarkImageView = UIImageView()
    
    override func prepareForReuse() {
        bookmarkImageView.removeFromSuperview()
    }
    
    func configure(with item: BillItem) {
        var configuration = UIListContentConfiguration.subtitleCell()
        configuration.text = item.title
        configuration.secondaryText = item.description
        configuration.textToSecondaryTextVerticalPadding = 5
        configuration.secondaryTextProperties.color = .darkGray
        configuration.secondaryTextProperties.font = .systemFont(ofSize: 13)

        accessoryType = .disclosureIndicator
        contentConfiguration = configuration
        
        if item.isSaved {
            let image = UIImage(systemName: "bookmark.fill")
            bookmarkImageView = UIImageView(image: image)
            bookmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(bookmarkImageView)
            NSLayoutConstraint.activate([
                bookmarkImageView
                    .topAnchor
                    .constraint(equalTo: contentView.topAnchor),
                bookmarkImageView
                    .trailingAnchor
                    .constraint(equalTo: trailingAnchor, constant: -12)
            ])
        }
    }
}
