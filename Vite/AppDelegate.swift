//
//  AppDelegate.swift
//  Vite
//
//  Created by Water on 2018/8/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import Fabric
import Crashlytics
import NSObject_Rx
import Vite_HDWalletKit
import ViteBusiness
import Firebase
import UserNotifications

#if OFFICIAL
import ViteCommunity
#endif

#if DEBUG || TEST
import Bagel
#endif

class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = FlutterRouter.shared

        plog(level: .info, log: "DidFinishLaunching", tag: .life)

        #if DEBUG || TEST
        Bagel.start()
        #endif

        #if OFFICIAL
        FirebaseApp.configure()
        VitePushManager.instance.start()
        ViteCommunity.register()
        //DiscoverViewController.createNavVC()
        ViteBusinessLanucher.instance.add(homePageSubTabViewController: self.createNavVC(), atIndex: 1)
        #elseif DAPP
        ViteBusinessLanucher.instance.add(homePageSubTabViewController: DebugHomeViewController.createNavVC(), atIndex: 2)
        #endif

        ViteBusinessLanucher.instance.start(with: window)
        return true
    }

    public func createNavVC() -> UIViewController {
        let discoverVC = FlutterRouterViewController(page: .discoverHome, title: "")
        let nav = BaseNavigationController(rootViewController: discoverVC).then {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            $0.tabBarItem.image = R.image.icon_tabbar_discover()?.withRenderingMode(.alwaysOriginal)
            $0.tabBarItem.selectedImage = R.image.icon_tabbar_discover_select()?.withRenderingMode(.alwaysOriginal)
        }
        return nav
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ViteBusinessLanucher.instance.application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
#if OFFICIAL
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        VitePushManager.instance.model.deviceToken = deviceToken.toHexString()
    }
#endif
}
