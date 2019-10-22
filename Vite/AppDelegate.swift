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
import vite_wallet_communication

#if OFFICIAL
import ViteCommunity
#endif

#if DEBUG || TEST
import Bagel
#endif

//@UIApplicationMain
@objc class AppDelegate: FLBFlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        plog(level: .info, log: "DidFinishLaunching", tag: .life)

        #if DEBUG || TEST
        Bagel.start()
        #endif

        #if OFFICIAL
        FirebaseApp.configure()
        VitePushManager.instance.start()
        ViteCommunity.register()
//        ViteBusinessLanucher.instance.add(homePageSubTabViewController: self.createNavVC(), atIndex: 2)
        ViteBusinessLanucher.instance.add(homePageSubTabViewController: DiscoverViewController.createNavVC(), atIndex: 3)
        #endif

        //after firebase
        GeneratedPluginRegistrant.register(with: self)
        let flutterRouter = FlutterRouter.shared
        FlutterBoostPlugin.sharedInstance()?.startFlutter(with: flutterRouter, onStart: { (_) in

        })
        ViteBusinessLanucher.instance.start(with: window)
        bindFlutter()
        return true
    }

    public func createNavVC() -> UIViewController {
        let vc = FlutterRouterViewController(page: .marketHome, title: "")
        let nav = BaseNavigationController(rootViewController: vc).then {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            $0.tabBarItem.image = ViteBusiness.R.image.icon_tabbar_market()?.withRenderingMode(.alwaysOriginal)
            $0.tabBarItem.selectedImage = ViteBusiness.R.image.icon_tabbar_market_select()?.withRenderingMode(.alwaysOriginal)
            $0.tabBarItem.tag = 1002
            $0.interactivePopGestureRecognizer?.isEnabled = false
            $0.tabBarItem.title = nil
        }

        return nav
    }

    func bindFlutter() {
        NotificationCenter.default.rx.notification(NSNotification.Name.goGateWayVC)
            .bind {  notification in
                let info = notification.object as! [String: Any]
                let gateway = info["gateway"] as! String
                let gatewayInfoVC = FlutterRouterViewController(page: .gatewayInfo(gateway), title: "Flutter Page")
                UIViewController.current?.navigationController?.pushViewController(gatewayInfoVC, animated: true)
            }
            .disposed(by: rx.disposeBag)
        NotificationCenter.default.rx.notification(NSNotification.Name.goTokenInfoVC)
            .bind { notification in
                let info = notification.object as! [String: Any]
                let tokenCode = info["tokenCode"] as! String
                let gatewayInfoVC = FlutterRouterViewController(page: .tokenInfo(tokenCode), title: "Flutter Page")
                UIViewController.current?.navigationController?.pushViewController(gatewayInfoVC, animated: true)
            }
            .disposed(by: rx.disposeBag)

        HDWalletManager.instance.accountDriver.drive(onNext: { (account) in
            ViteFlutterCommunication.shareInstance()?.currentViteAddress = account?.address ?? ""
            ViteFlutterCommunication.shareInstance()?.events?("changeConfig")
        }).disposed(by: rx.disposeBag)

        AppSettingsService.instance.currencyDriver.drive(onNext: { (code) in
            ViteFlutterCommunication.shareInstance()?.currency = code.rawValue
            ViteFlutterCommunication.shareInstance()?.events?("changeConfig")
        }).disposed(by: rx.disposeBag)

        ViteFlutterCommunication.shareInstance()?.lang = LocalizationService.sharedInstance.currentLanguage.rawValue
        NotificationCenter.default.rx.notification(.languageChanged).asObservable().bind { _ in
            ViteFlutterCommunication.shareInstance()?.lang = LocalizationService.sharedInstance.currentLanguage.rawValue
            ViteFlutterCommunication.shareInstance()?.events?("changeConfig")
        }.disposed(by: rx.disposeBag)

        ViteFlutterCommunication.shareInstance()?.env = {
            switch ViteConst.instance.envType {
            case .test:
                return "test"
            case .stage, .premainnet:
                return "online"
            }
        }()
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ViteBusinessLanucher.instance.application(app, open: url, options: options)
    }

    override func applicationWillResignActive(_ application: UIApplication) {

    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    override func applicationWillEnterForeground(_ application: UIApplication) {

    }

    override func applicationDidBecomeActive(_ application: UIApplication) {

    }

    override func applicationWillTerminate(_ application: UIApplication) {

    }
#if OFFICIAL
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        VitePushManager.instance.model.deviceToken = deviceToken.toHexString()
    }
#endif
}
