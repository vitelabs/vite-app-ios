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
import ViteCommunity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        plog(level: .info, log: "DidFinishLaunching", tag: .life)

        Statistics.initialize()
        handleNotification()
        _ = LocalizationService.sharedInstance

        goShowIntroViewPage()

        AppSettingsService.instance.start()
        TokenCacheService.instance.start()
        AutoGatheringService.instance.start()
        FetchBalanceInfoService.instance.start()
        FetchQuotaService.instance.start()
        #if !ENTERPRISE
        VitePushManager.shared().start(launchOptions:
            launchOptions ?? [:])
        #endif
        return true
    }

    func handleNotification() {
        let b = NotificationCenter.default.rx.notification(.logoutDidFinish)
        let c = NotificationCenter.default.rx.notification(.finishShowIntroPage)
        Observable.of(b, c)
            .merge()
            .takeUntil(self.rx.deallocated)
            .subscribe {[weak self] (_) in
                guard let `self` = self else { return }
                self.handleRootVC()
            }.disposed(by: rx.disposeBag)

        let createAccountSuccess = NotificationCenter.default.rx.notification(.createAccountSuccess)
        let loginDidFinish = NotificationCenter.default.rx.notification(.loginDidFinish)
        let languageChangedInSetting = NotificationCenter.default.rx.notification(.languageChangedInSetting)
        let unlockDidSuccess = NotificationCenter.default.rx.notification(.unlockDidSuccess)

        Observable.of(createAccountSuccess, loginDidFinish, languageChangedInSetting, unlockDidSuccess)
            .merge()
            .takeUntil(self.rx.deallocated)
            .subscribe {[weak self] (_) in
                guard let `self` = self else { return }
                self.goHomePage()
            }.disposed(by: rx.disposeBag)
    }

    func handleRootVC() {

        if HDWalletManager.instance.canUnLock {
            if !HDWalletManager.instance.isRequireAuthentication,
                let wallet = KeychainService.instance.currentWallet,
                wallet.uuid == HDWalletManager.instance.wallet?.uuid,
                HDWalletManager.instance.loginCurrent(encryptKey: wallet.encryptKey) {
                self.goHomePage()
                return
            } else {
                self.goLockPage()
                return
            }
        }

        if HDWalletManager.instance.isEmpty {
            let rootVC = CreateAccountHomeViewController()
            rootVC.automaticallyShowDismissButton = false
            let nav = BaseNavigationController(rootViewController: rootVC)
            window.rootViewController = nav
            window.makeKeyAndVisible()
        } else {
            let rootVC = LoginViewController()
            rootVC.automaticallyShowDismissButton = false
            let nav = BaseNavigationController(rootViewController: rootVC)
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }

    func goShowIntroViewPage() {
        let introViewPageVersion = UserDefaultsService.instance.objectForKey("IntroView", inCollection: "IntroViewPageVersion") as? String  ?? ""
        if introViewPageVersion != Constants.IntroductionPageVersion {
            let vc = IntroductionViewController()
            window.rootViewController = vc
            window.makeKeyAndVisible()
        } else {
            handleRootVC()
        }
    }

    func goLockPage() {
        let rootVC: BaseViewController
        if HDWalletManager.instance.isAuthenticatedByBiometry {
            rootVC = LockViewController()
        } else {
            rootVC = LockPwdViewController()
            rootVC.automaticallyShowDismissButton = false
        }
        let nav = BaseNavigationController(rootViewController: rootVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func goHomePage() {
        let rootVC = HomeViewController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
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
