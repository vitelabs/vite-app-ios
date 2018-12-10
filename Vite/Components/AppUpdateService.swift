//
//  AppUpdateService.swift
//  Vite
//
//  Created by Water on 2018/9/27.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import ViteUtils

class AppUpdateService: NSObject {

    struct UpdateInfo: Mappable {

        fileprivate var isForce = true
        fileprivate var build = 0
        fileprivate var urlString = ""
        fileprivate var forced: Int?
        fileprivate var title: StringWrapper = StringWrapper(string: "")
        fileprivate var message: StringWrapper = StringWrapper(string: "")
        fileprivate var okTitle: StringWrapper?
        fileprivate var cancelTitle: StringWrapper?

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
            forced <- map["forced"]
            title <- map["title"]
            message <- map["message"]
            okTitle <- map["okTitle"]
            cancelTitle <- map["cancelTitle"]
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
                        showUpdate(info: info, current: current)
                    }
                }
            case .failure(let error):
                plog(level: .warning, log: error.message, tag: .getConfig)
                GCD.delay(2, task: { self.checkUpdate() })
            }
        }
    }

    fileprivate static func showUpdate(info: UpdateInfo, current: Int) {

        var isForce = info.isForce
        if !isForce {
            if let forced = info.forced {
                if current < forced {
                    isForce = true
                }
            }
        }

        if isForce {
            func showAlert() {
                Alert.show(title: info.title.string, message: info.message.string, actions: [
                    (.default(title: info.okTitle?.string ?? R.string.localizable.updateApp()), { _ in
                        UIApplication.shared.open(info.url, options: [:], completionHandler: nil)
                        showAlert()
                    }),
                    ])
            }
            showAlert()
        } else {

            enum Key: String {
                case collection = "AppUpdate"
                case ignoreBuild = "ignoreBuild"
            }

            var ignoreBuild = 0
            if let num = UserDefaultsService.instance.objectForKey(Key.ignoreBuild.rawValue, inCollection: Key.collection.rawValue) as? Int {
                ignoreBuild = num
            }
            guard ignoreBuild != info.build else { return }

            Alert.show(title: info.title.string, message: info.message.string, actions: [
                (.cancel, { _ in
                    UserDefaultsService.instance.setObject(info.build, forKey: Key.ignoreBuild.rawValue, inCollection: Key.collection.rawValue)
                }),
                (.default(title: info.okTitle?.string ?? R.string.localizable.updateApp()), { _ in
                    UIApplication.shared.open(info.url, options: [:], completionHandler: nil)
                }),
                ])
        }
    }
}
