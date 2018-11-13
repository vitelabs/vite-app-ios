//
//  AppUpdateVM.swift
//  Vite
//
//  Created by Water on 2018/9/27.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

class AppUpdateVM: NSObject {

    struct UpdateInfo: Mappable {

        fileprivate var isForce = true
        fileprivate var build = 0
        fileprivate var urlString = ""
        fileprivate var title: StringWrapper = StringWrapper(string: "")
        fileprivate var message: StringWrapper = StringWrapper(string: "")

        fileprivate var url: URL {
            return URL(string: urlString)!
        }

        init?(map: Map) {
            guard let urlString = map.JSON["url"] as? String, let _ = URL(string: urlString) else {
                return nil
            }
        }

        mutating func mapping(map: Map) {
            isForce <- map["isForce"]
            build <- map["build"]
            urlString <- map["url"]
            title <- map["title"]
            message <- map["message"]
        }
    }

    static func checkUpdate() {

        COSProvider.instance.checkUpdate { (result) in
            switch result {
            case .success(let jsonString):
                plog(level: .debug, log: "check app update finished", tag: .getConfig)
                if let string = jsonString,
                    let info = UpdateInfo(JSONString: string),
                    let current = Int(Bundle.main.buildNumber) {
                    if current < info.build {
                        showUpdate(info: info)
                    }
                }
            case .error(let error):
                plog(level: .warning, log: error.message, tag: .getConfig)
                GCD.delay(2, task: { self.checkUpdate() })
            }
        }
    }

    fileprivate static func showUpdate(info: UpdateInfo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let rootVC = appDelegate.window?.rootViewController else { return }
        var top = rootVC
        while let presentedViewController = top.presentedViewController {
            top = presentedViewController
        }

        if info.isForce {
            func showAlert() {
                top.displayConfirmAlter(title: info.title.string, message: info.message.string, done: R.string.localizable.updateApp.key.localized(), doneHandler: {
                    UIApplication.shared.open(info.url, options: [:], completionHandler: nil)
                    showAlert()
                })
            }
            showAlert()
        } else {
            top.displayAlter(title: info.title.string, message: info.message.string, cancel: R.string.localizable.cancel.key.localized(), done: R.string.localizable.updateApp.key.localized(), doneHandler: {
                UIApplication.shared.open(info.url, options: [:], completionHandler: nil)
            })
        }
    }
}
