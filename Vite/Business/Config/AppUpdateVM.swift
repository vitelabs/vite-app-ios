//
//  AppUpdateVM.swift
//  Vite
//
//  Created by Water on 2018/9/27.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Moya
import SwiftyJSON

class AppUpdateVM: NSObject {

    static func checkUpdate() {
        ServerProvider.instance.getAppUpdate { (result) in
            switch result {
            case .success(let info):
                plog(level: .debug, log: "check app update finished", tag: .getConfig)
                guard info.isOpen else { return }
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                guard let rootVC = appDelegate.window?.rootViewController else { return }
                var top = rootVC
                while let presentedViewController = top.presentedViewController {
                    top = presentedViewController
                }

                if info.isForce {
                    func showAlert() {
                        top.displayConfirmAlter(title: info.title, message: info.message, done: R.string.localizable.updateApp.key.localized(), doneHandler: {
                            UIApplication.shared.open(info.url, options: [:], completionHandler: nil)
                            showAlert()
                        })
                    }
                    showAlert()
                } else {
                    top.displayAlter(title: info.title, message: info.message, cancel: R.string.localizable.cancel.key.localized(), done: R.string.localizable.updateApp.key.localized(), doneHandler: {
                        UIApplication.shared.open(info.url, options: [:], completionHandler: nil)
                    })
                }

            case .error(let error):
                plog(level: .warning, log: error.localizedDescription, tag: .getConfig)
                GCD.delay(2, task: {
                    checkUpdate()
                })
            }
        }
    }
}
