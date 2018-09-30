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
    public func fetchUpdateInfo() {
        let policies: [String: ServerTrustPolicy] = [:]
        let manager = Manager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
        )
        let provider =  MoyaProvider<ViteAPI>(manager: manager)

        let viteAppServiceRequest = ViteAppServiceRequest.init(provider: provider)

        let _ = viteAppServiceRequest.getAppUpdate().done { versions in
            guard let version = versions.first else { return }

            let dic = JSON.init(parseJSON: version)

            let isOpen = dic["isOpen"].boolValue
            if isOpen {
                let isForce = dic["version"].dictionaryValue["isForce"]?.boolValue ?? true
                let message = dic["version"].dictionaryValue["message"]?.stringValue ?? ""
                let url = dic["version"].dictionaryValue["url"]?.stringValue ?? ""

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                guard let rootVC = appDelegate.window?.rootViewController else { return }
                var top = rootVC
                while let presentedViewController = top.presentedViewController {
                    top = presentedViewController
                }
                if isForce {
                    top.displayConfirmAlter(title: message, done: R.string.localizable.updateApp.key.localized(), doneHandler: {
                        UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
                        top.displayConfirmAlter(title: message, done: R.string.localizable.updateApp.key.localized(), doneHandler: {
                              UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
                        })
                    })
                } else {
                    top.displayAlter(title: message, message: "", cancel: R.string.localizable.cancel.key.localized(), done: R.string.localizable.updateApp.key.localized(), doneHandler: {
                        UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
                    })
                }
            }
        }

    }
}
