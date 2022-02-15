//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let database = Database()
    let webservice = WebService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        webservice.fetchBills { [self] result in
            database.context.perform {
                switch result {
                case .success(let bills):
                    for bill in bills {
                        let cdBill = CDBill(context: database.context)
                        cdBill.billNum = bill.billNum
                        cdBill.billStatus = bill.billStatus
                        let billCategory = CDBillCategory(context: database.context)
                        billCategory.cdName = bill.category
                        cdBill.category = billCategory
                        // cdBill.committees = bill.committees
                        cdBill.fullTopic = bill.fullTopic
                        cdBill.info = bill.description
                        cdBill.longTitle = bill.longTitle
                        cdBill.originalChamber = bill.originalChamber
                        cdBill.sessionTitle = bill.sessionTitle
                        // cdBill.sponsors
                        cdBill.title = bill.title
                        cdBill.websiteLink = bill.websiteLink
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                NotificationCenter.default.post(name: .billsUpdated, object: nil)
                database.saveContext()
            }
        }
        // webservice.fetchLegislators()
        // webservice.fetchCommittees()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension Notification.Name {
    static let billsUpdated = Notification.Name(rawValue: "Bills Updated")
}
