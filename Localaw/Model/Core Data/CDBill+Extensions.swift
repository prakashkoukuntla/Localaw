//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation

extension CDBill: Bill {
    var subjects: [BillCategory] {
        print(cdSubjects)
        return []
    }
    
    var sponsors: [Legislator] {
        print(cdSponsors)
        return []
    }
    
    var committees: [Committee] {
        print(cdCommittees)
        return []
    }
    
    var name: String { cdName ?? "" }
    
    var longSummary: String { cdLongSummary ?? "" }
    
    var shortSummary: String { cdShortSummary ?? "" }
    
    var session: String { cdSession ?? "" }
    
    var billID: String { cdBillID ?? "" }
    
}
