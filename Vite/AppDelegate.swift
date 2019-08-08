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

        plog(level: .info, log: "DidFinishLaunching", tag: .life)

        #if DEBUG || TEST
        Bagel.start()
        #endif

        #if OFFICIAL
        FirebaseApp.configure()
        VitePushManager.instance.start()
        ViteCommunity.register()
        ViteBusinessLanucher.instance.add(homePageSubTabViewController: DiscoverViewController.createNavVC(), atIndex: 2)
        #elseif DAPP
        ViteBusinessLanucher.instance.add(homePageSubTabViewController: DebugHomeViewController.createNavVC(), atIndex: 3)
        #endif

        ViteBusinessLanucher.instance.start(with: window)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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
