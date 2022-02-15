//
//  Copyright © 2022 Prakash Koukuntla. All rights reserved.
//  

import Foundation

enum Result<Success, Failure: LocalizedError> {
    case success(Success)
    case failure(Failure)
}

enum WebServiceError: Error, LocalizedError {
    case noData
    case error(Error)

    var errorDescription: String? {
        switch self {
        case .noData:
            return "No Data"
        case .error(let error):
            return error.localizedDescription
        }
    }
}

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
        var sponsors: [Sponsor]?
        var committees: [Committee]
        var summarizedHistory: [History]
    }

    struct History: Codable {
        var location: String
        var action: String
        var date: String // YYYY-MM-DD
    }

    struct Sponsor: Codable {
        var id: Int
        var name: String
        var chamber: String
        var memberId: String
        var email: String?
        var district: Int?
        var avatar: String?
        var counties: String? // comma separated list of names
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
        var counties: String // comma separated list
        var leadershipPosition: String?
        var committees: [LegislatorCommittee]
        var district: Int
    }

    struct LegislatorCommittee: Codable {
        var name: String
        var committeeUuid: String
    }

    struct BaseCommittee: Codable {
        var id: Int
        var uuid: String
        var chamber: String
        var name: String
        var staffEmail: String
        var description: String // conflicts with custom string convertible
        var committeeType: String
        var committeeMembers: [CommitteeMember]
    }

    struct CommitteeMember: Codable {
        var id: Int
        var memberId: String
        var fullName: String
        var memberPosition: String?
        var chamber: String
        var email: String
        var phone: String
    }

    func fetchBills(completion: @escaping (Result<[Bill], WebServiceError>) -> Void) {
        guard let url = URL(string: "https://cogar.denvertech.org/api/v1/bills.json") else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(.error(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let bills = try decoder.decode([Bill].self, from: data)
                completion(.success(bills))
            } catch {
                completion(.failure(.error(error)))
            }
        }
        dataTask.resume()
    }

    func fetchLegislators() {
        guard let url = URL(string: "https://cogar.denvertech.org/api/v1/legislators.json") else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
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
            } catch let err as NSError {
                print(err)
            }
        }
        dataTask.resume()
    }

    func fetchCommittees() {
        guard let url = URL(string: "https://cogar.denvertech.org/api/v1/committees.json") else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
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
                let committees = try decoder.decode([BaseCommittee].self, from: data)
                print(committees)
            } catch let err as NSError {
                print(err)
            }
        }
        dataTask.resume()
    }
}
