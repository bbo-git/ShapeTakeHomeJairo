//
//  AppDelegate.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainCoordinator: MainCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.isHidden = false
        let nav = UINavigationController()
        mainCoordinator = MainCoordinator(nav: nav)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        mainCoordinator?.start()
        self.window = window
        return true
    }

}

