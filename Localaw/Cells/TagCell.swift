//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    var label: UILabel
    
    /// Replacement for `isSelected`
    var isChosen: Bool {
        didSet {
            configureViewForSelectedState()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        label = UILabel()
        label.numberOfLines = 0
        isChosen = false
        
        super.init(frame: frame)
        
        contentView.embed(view: label, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        anchor.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            anchor,
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isChosen = false
    }
    
    // MARK: - Configuration
    
    func configureViewForSelectedState() {
        if isChosen {
            label.textColor = .white
            contentView.backgroundColor = .legalPurple
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
