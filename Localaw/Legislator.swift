//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation
import UIKit

protocol Legislator {
    var name: String { get }
    var profilePicture: UIImage { get }
    var email: String { get }
    var party: String { get }
    var leadershipPosition: String { get }
    var committeeAssignments: [Committee] { get }
    var county: [String] { get }
    var district: Int { get }
}
