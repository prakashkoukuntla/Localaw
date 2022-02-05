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
        webservice.fetchBills { result in
            switch result {
            case .success(let bills):
                print(bills)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //webservice.fetchLegislators()
        //webservice.fetchCommittees()
        let bill = CDBill(context: database.context)
        bill.cdName = "name"
        bill.cdSession = "session"
        bill.cdDateIntroduced = Date()
        let legislator = CDLegislator(context: database.context)
        legislator.cdName = "first last"
        legislator.cdEmail = "politicsstuff@colorado.co"
        legislator.cdParty = "green"
        legislator.addToCdBills(bill)
        let county = CDCounty(context: database.context)
        county.cdCounty = "big"
        county.addToCdLegislators(legislator)
        database.saveContext()
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
