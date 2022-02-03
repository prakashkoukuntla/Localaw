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
    
    struct Legislator: Codable {
        var id: Int
        var firstName: String
        var lastName: String
        var officialName: String
        var party: String
        var pictureUrl: String
        var chamber: String
        var email: String
        var memberId: String
        var counties: String //comma separated list
        var leadershipPosition: String?
        var committees: [LegislatorCommittee]
        var district: Int
    }
    
    struct LegislatorCommittee: Codable {
        var name: String
        var committeeUuid: String
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
        guard let url = URL(string: "https://cogar.denvertech.org/api/v1/legislators.json") else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            guard let data = data else {
                fatalError("no data")
            }
            print(data)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let legislators = try decoder.decode([Legislator].self, from: data)
                print(legislators)
            } catch let e as NSError {
                print(e)
            }
        }
        dataTask.resume()
    }
}
