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
import ViteUtils
import ViteBusiness

#if OFFICIAL || TEST || ENTERPRISE
import ViteCommunity
#endif

class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        plog(level: .info, log: "DidFinishLaunching", tag: .life)

        #if OFFICIAL || TEST || ENTERPRISE
        #if !ENTERPRISE
        VitePushManager.shared().start(launchOptions: launchOptions ?? [:])
        #endif
        ViteCommunity.register()
        ViteBusinessLanucher.instance.add(homePageSubTabViewController: DiscoverViewController.createNavVC(), atIndex: 2)
        #endif

        ViteBusinessLanucher.instance.start(with: window)

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
