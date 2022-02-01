//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import Foundation

extension CDBill: Bill {
    var subjects: [BillCategory] {
        guard let subjects = cdSubjects?.allObjects as? [BillCategory] else {
            assertionFailure("Failed to unwrap the subjects")
            return []
        }
        return subjects
    }
    
    var sponsors: [Legislator] {
        guard let sponsors = cdSponsors?.allObjects as? [Legislator] else {
            assertionFailure("Failed to unwrap the subjects")
            return []
        }
        return sponsors
    }
    
    var committees: [Committee] {
        guard let committees = cdCommittees?.allObjects as? [Committee] else {
            assertionFailure("Failed to unwrap the subjects")
            return []
        }
        return committees
    }
    
    var name: String { cdName ?? "" }
    
    var longSummary: String { cdLongSummary ?? "" }
    
    var shortSummary: String { cdShortSummary ?? "" }
    
    var session: String { cdSession ?? "" }
    
    var billID: String { cdBillID ?? "" }
    
    var dateIntroduced: Date { cdDateIntroduced ?? .distantPast }
    
}
