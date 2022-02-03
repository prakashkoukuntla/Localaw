//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//  

import Foundation

class WebService {
    struct Bill: Codable {
        var billNum: String
        var title: String
        var billStatus: String
        var fullTopic: String
        var originalChamber: String
        var category: String
        var longTitle: String
        var description: String
        var sessionTitle: String
        var websiteLink: String
        var sponsors: [Sponsor]
        var committees: [Committee]
    }
    
    struct Sponsor: Codable {
        var id: Int
        var name: String
        var chamber: String
        var email: String
        var district: Int
        var avatar: String
        var counties: String // comma separated list of names
    }
    
    struct Committee: Codable {
        var id: Int
        var uuid: String
        var chamber: String
        var name: String
    }
    
    func fetchBills() {
        guard let url = URL(string: "https://cogar.denvertech.org/api/v1/bills.json") else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            guard let data = data else {
                fatalError("no data")
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let bills = try? decoder.decode([Bill].self, from: data)
            print(bills)
        }
        dataTask.resume()
    }
    func fetchLegislators() {
        
    }
}
