//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation

extension CDBill: Bill {
    var subjects: [BillCategory] {
        categories as? Set<CDBillCategory>
    }
    
    var sponsors: [Legislator] {
        <#code#>
    }
    
    var committees: [Committee] {
        <#code#>
    }
    
    var name: String { cdName ?? "" }
    
    var longSummary: String { cdLongSummary ?? "" }
    
    var shortSummary: String { cdShortSummary ?? "" }
    
    var session: String { cdSession ?? "" }
    
    var billID: String { cdBillID ?? "" }
    
}
