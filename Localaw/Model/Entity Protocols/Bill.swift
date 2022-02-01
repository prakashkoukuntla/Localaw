//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation

protocol Bill {
    var name: String { get }
    var longSummary: String { get }
    var shortSummary: String { get }
    var session: String { get }
    var billID: String { get }
    var subjects: [BillCategory] { get }
    var sponsors: [Legislator] { get }
    var committees: [Committee] { get }

    var dateIntroduced: Date { get }
}
