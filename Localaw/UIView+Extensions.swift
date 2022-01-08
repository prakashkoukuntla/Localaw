//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

extension UIView {
    func embed(view: UIView, padding: UIEdgeInsets = .zero, width: CGFloat? = nil, height: CGFloat? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding.bottom)
        bottom.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding.right),
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            bottom
        ])
        
        if let width = width {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: width)
            ])
        }

        if let height = height {
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: height)
            ])
        }
    }
}
