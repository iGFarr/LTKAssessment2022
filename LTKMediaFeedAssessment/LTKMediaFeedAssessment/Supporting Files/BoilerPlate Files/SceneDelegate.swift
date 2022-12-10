//
//  SceneDelegate.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private(set) static var shared: SceneDelegate?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        Self.shared = self
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        let viewController = LTKLaunchViewController()
        let navViewControllerHomePage = UINavigationController(rootViewController: viewController)
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            let font: UIFont = .LTKFonts.primary
            let color: UIColor = .LTKTheme.tertiary
            
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.obliqueness: LTKConstants.UI.italicizeFontNSKey,
                NSAttributedString.Key.foregroundColor: color
            ]
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = .systemBackground
            navigationBarAppearance.shadowColor = .clear
            navViewControllerHomePage.navigationBar.standardAppearance = navigationBarAppearance
            navViewControllerHomePage.navigationBar.compactAppearance = navigationBarAppearance
            navViewControllerHomePage.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            navViewControllerHomePage.navigationBar.tintColor = .LTKTheme.tertiary
            navViewControllerHomePage.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            
            tabBarController.viewControllers = [navViewControllerHomePage]
            tabBarController.tabBar.tintColor = .LTKTheme.tertiary
            let tabBarTuples: [(title: String, imageName: String)] = [
                ("Favorites", "heart"),
                ("Creators", "person.crop.square.filled.and.at.rectangle"),
                ("Discover", "square.grid.2x2"),
                ("Menu", "text.viewfinder")
            ]
            for num in 0..<4 {
                let blankController = LTKBlankViewController()
                let navViewBlankController = UINavigationController(rootViewController: blankController)
                navViewBlankController.navigationBar.standardAppearance = navigationBarAppearance
                navViewBlankController.navigationBar.compactAppearance = navigationBarAppearance
                navViewBlankController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
                navViewBlankController.navigationBar.tintColor = .LTKTheme.tertiary
                var title = ""
                var imageName = ""
                if tabBarTuples.count > num {
                    title = tabBarTuples[num].title
                    imageName = tabBarTuples[num].imageName
                }
                navViewBlankController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: num + 1)
                tabBarController.viewControllers?.append(navViewBlankController)
            }
        }
        window?.rootViewController = tabBarController
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
    }


}

