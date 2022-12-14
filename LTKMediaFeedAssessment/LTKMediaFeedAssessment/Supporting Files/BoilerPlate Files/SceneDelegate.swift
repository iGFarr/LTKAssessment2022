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
        var viewControllersForTabBar = [UINavigationController]()
        if #available(iOS 15, *) {
            let defaultAttributes = LTKUIUtilities.getDefaultTitleAttributes()
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.titleTextAttributes = defaultAttributes
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = .LTKTheme.tertiary
            
            let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
            barButtonItemAppearance.normal.titleTextAttributes = defaultAttributes
            barButtonItemAppearance.highlighted.titleTextAttributes = defaultAttributes
            navigationBarAppearance.backButtonAppearance = barButtonItemAppearance
            tabBarController.tabBar.tintColor = .LTKTheme.tertiary
            let tabBarTuples: [(title: String, imageName: String)] = [
                ("Home-Tab".localized(), "house"),
                ("Favorites-Tab".localized(), "heart"),
                ("Creators-Tab".localized(), "person.crop.square.filled.and.at.rectangle"),
                ("Discover-Tab".localized(), "square.grid.2x2"),
                ("Menu-Tab".localized(), "text.viewfinder")
            ]
            for num in 0..<5 {
                var viewController = UIViewController()

                switch num {
                case 0:
                    viewController = LTKLaunchViewController()
                case 1...3:
                    viewController = LTKBlankViewController()
                case 4:
                    viewController = LTKMenuViewController()
                default:
                    break
                }
                var title = ""
                var imageName = ""
                if tabBarTuples.count > num {
                    title = tabBarTuples[num].title
                    imageName = tabBarTuples[num].imageName
                }
                let navViewController = UINavigationController(rootViewController: viewController)
                navViewController.navigationBar.standardAppearance = navigationBarAppearance
                navViewController.navigationBar.compactAppearance = navigationBarAppearance
                navViewController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
                navViewController.navigationBar.tintColor = .LTKTheme.tertiary
                navViewController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: num)
                navViewController.tabBarItem.setTitleTextAttributes(LTKUIUtilities.getDefaultTitleAttributes(), for: .normal)
                navViewController.visibleViewController?.title = tabBarTuples[num].title
                navViewController.visibleViewController?.navigationItem.titleView = UIView()
                viewControllersForTabBar.append(navViewController)
            }
            tabBarController.viewControllers = viewControllersForTabBar
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

