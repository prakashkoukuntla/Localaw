//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

extension CDBillCategory: BillCategory {
    var name: String { cdName ?? "" }

    var icon: UIImage {
        if let icon = cdIcon, let image = UIImage(data: icon) {
            return image
        } else {
            return UIImage(systemName: "doc.text") ?? UIImage()
        }
    }
}
