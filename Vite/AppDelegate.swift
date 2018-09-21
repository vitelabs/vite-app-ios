//
//  AppDelegate.swift
//  Vite
//
//  Created by Water on 2018/8/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import Vite_keystore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        startBaiduMobileStat()
        handleNotification()
        _ = SettingDataService.sharedInstance.getCurrentLanguage()

        window = UIWindow(frame: UIScreen.main.bounds)
        handleRootVC()

        AutoGatheringService.instance.start()
        FetchBalanceInfoService.instance.start()

        return true
    }

    func handleNotification() {
        let a = NotificationCenter.default.rx.notification(.createAccountSuccess)
        let b = NotificationCenter.default.rx.notification(.logoutDidFinish)
        let c = NotificationCenter.default.rx.notification(.loginDidFinish)

        Observable.of(a, b, c)
            .merge()
            .takeUntil(self.rx.deallocated)
            .subscribe {[weak self] (_) in
                guard let `self` = self else { return }
                self.handleRootVC()
            }.disposed(by: rx.disposeBag)

        //change language in setting page
        NotificationCenter.default.rx
            .notification(.languageChangedInSetting)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.goHomePage()
            }).disposed(by: rx.disposeBag)
    }

    func handleRootVC() {
        if  WalletDataService.shareInstance.isExistWallet() {
            let rootVC = CreateAccountHomeViewController()
            rootVC.automaticallyShowDismissButton = false
            let nav = BaseNavigationController(rootViewController: rootVC)
            window?.rootViewController = nav
        } else if WalletDataService.shareInstance.existWalletAndLogout() {
            let rootVC = LoginViewController()
            rootVC.automaticallyShowDismissButton = false
            let nav = BaseNavigationController(rootViewController: rootVC)
            window?.rootViewController = nav
        } else {
            self.goHomePage()
            return
        }
        window?.makeKeyAndVisible()
    }

    func goHomePage() {
    HDWalletManager.instance.updateAccount(WalletDataService.shareInstance.defaultWalletAccount!)
        let rootVC = HomeViewController()
        window?.rootViewController = rootVC
         window?.makeKeyAndVisible()
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

    func startBaiduMobileStat() {
        let statTracker: BaiduMobStat = BaiduMobStat.default()
        statTracker.shortAppVersion  =  (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        statTracker.start(withAppId: "e74c7f32c0")
    }

}
