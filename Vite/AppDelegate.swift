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
import ViteCommunity
import ViteBusiness

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        #if !ENTERPRISE
        VitePushManager.shared().start(launchOptions: launchOptions ?? [:])
        #endif
        plog(level: .info, log: "DidFinishLaunching", tag: .life)
        ViteCommunity.register()
       ViteBusinessLanucher.instance.add(homePageSubTabViewController: DiscoverViewController.createNavVC(), atIndex: 2)

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
