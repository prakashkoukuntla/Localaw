//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Variables

    var window: UIWindow?

    lazy var tabBar: UITabBarController = {
        let tabBar = UITabBarController()
        tabBar.tabBar.tintColor = .legalPurple
        tabBar.viewControllers = [
            makeRecentBillsViewController(context: database.context),
            makeSavedBillsViewController(context: database.context),
            makeSettingsViewController()
        ]
        return tabBar
    }()

    var database: Database {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("The application did not launch properly.")
        }
        return delegate.database
    }

    // MARK: - Scene lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = scene as? UIWindowScene else {
            assertionFailure("Failed to get the scene")
            return
        }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        showBillCategoriesModalIfNeeded()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        database.saveContext()
    }
}

// MARK: - Configuration

extension SceneDelegate {

    func showBillCategoriesModalIfNeeded() {
        UserDefaults.standard.set(true, forKey: "wasLaunched")
        guard let _ = UserDefaults.standard.array(forKey: "selectedCategories") else {
            let controller = CategorySelectionViewController(context: database.context, selectedCategories: [])
            tabBar.present(controller, animated: true, completion: nil)
            return
        }
    }
}

// MARK: - Factory

extension SceneDelegate {
    func makeSettingsViewController() -> UIViewController {
        let controller = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }

    func makeRecentBillsViewController(context: NSManagedObjectContext) -> UIViewController {
        let controller = RecentBillsViewController(context: context)
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }

    func makeSavedBillsViewController(context: NSManagedObjectContext) -> UIViewController {
        let controller = SavedBillsViewController(context: context)
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
}
