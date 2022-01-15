//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

class SpacerView: UIView {
    init() {
        super.init(frame: .zero)
        setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
