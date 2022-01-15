//
//  Copyright © 2021 Prakash Koukuntla. All rights reserved.
//  

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = scene as? UIWindowScene else
        {
            assertionFailure("Failed to get the scene")
            return
        }
        window = UIWindow(windowScene: scene)
        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            makeRecentBillsViewController(),
            makeSavedBillsViewController(),
            makeSettingsViewController()
        ]
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        //guard !UserDefaults.standard.bool(forKey: "wasLaunched") else { return }
        UserDefaults.standard.set(true, forKey: "wasLaunched")
        // UserDefaults.standard.set(categories, forKey: "selectedCategories")
        print(UserDefaults.standard.array(forKey: "selectedCategories"))
        guard let _ = UserDefaults.standard.array(forKey: "selectedCategories") else  {
            let controller = CategorySelectionViewController()
            tabBar.present(controller, animated: true, completion: nil)
            return
        }
        

    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

// MARK: - Factory
extension SceneDelegate {
    func makeSettingsViewController() -> UIViewController {
        let controller = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    func makeRecentBillsViewController() -> UIViewController {
        let controller = RecentBillsViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    func makeSavedBillsViewController() -> UIViewController {
        let controller = SavedBillsViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
}
