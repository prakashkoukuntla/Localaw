//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation

protocol Committee {
    var name: String { get }
    var summary: String { get }
    var contacts: [Contact] { get }
    var email: String { get }
    var members: [Legislator] { get }
    var type: String { get }

}
