//
//  AppDelegate.swift
//  Vite
//
//  Created by Water on 2018/8/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = SettingDataService.sharedInstance.getCurrentLanguage()

        #if true
        let rootVC = LoginViewController()
        rootVC.automaticallyShowDismissButton = false
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = BaseNavigationController(rootViewController: rootVC)

        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        #else
        let rootVC = HomeViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        #endif
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}
