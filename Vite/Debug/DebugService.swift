//
//  DebugService.swift
//  Vite
//
//  Created by Stone on 2018/10/23.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

class DebugService: Mappable {
    static let instance = DebugService()
    fileprivate let fileHelper = FileHelper(.library, appending: FileHelper.appPathComponent)
    fileprivate static let saveKey = "DebugService"

    let rpcDefaultTestEnvironmentUrl = URL(string: "http://45.40.197.46:48132")!

    enum AppEnvironment: Int {
        case test = 0
        case stage = 1
        case online = 2
        case custom = -1

        var name: String {
            switch self {
            case .test:
                return "Test"
            case .stage:
                return "Stage"
            case .online:
                return "Online"
            case .custom:
                return "Custom"
            }
        }

        static var allValues: [AppEnvironment] = [.test, .stage, .online]
    }

    enum ConfigEnvironment: Int {
        case test = 0
        case stage = 1
        case online = 2

        static var allValues: [ConfigEnvironment] = [.test, .stage, .online]

        var name: String {
            switch self {
            case .test:
                return "Test"
            case .stage:
                return "Stage"
            case .online:
                return "Online"
            }
        }

        var url: URL {
            switch self {
            case .test:
                return URL(string: "https://testnet-vite-test-1257137467.cos.ap-beijing.myqcloud.com/config")!
            case .stage:
                return URL(string: "https://testnet-vite-stage-1257137467.cos.ap-beijing.myqcloud.com/config")!
            case .online:
                return URL(string: "https://testnet-vite-1257137467.cos.ap-hongkong.myqcloud.com/config")!
            }
        }
    }

    var appEnvironment = AppEnvironment.test {
        didSet {
            guard appEnvironment != oldValue else { return }
            switch self.appEnvironment {
            case .test:
                useBigDifficulty = true
                configEnvironment = .test
                rpcUseOnlineUrl = false
                rpcCustomUrl = ""
            case .stage:
                useBigDifficulty = true
                configEnvironment = .stage
                rpcUseOnlineUrl = true
            case .online:
                useBigDifficulty = true
                configEnvironment = .online
                rpcUseOnlineUrl = true
            case .custom:
                break
            }
            pri_save()
        }
    }

    private func updateAppEnvironment() {
        if useBigDifficulty == true && configEnvironment == ConfigEnvironment.test && rpcUseOnlineUrl == false && rpcCustomUrl == "" {
            appEnvironment = .test
        } else if useBigDifficulty == true && configEnvironment == ConfigEnvironment.stage && rpcUseOnlineUrl == true {
            appEnvironment = .stage
        } else if useBigDifficulty == true && configEnvironment == ConfigEnvironment.online && rpcUseOnlineUrl == true {
            appEnvironment = .online
        } else {
            appEnvironment = .custom
        }
    }

    var useBigDifficulty = true {
        didSet {
            guard useBigDifficulty != oldValue else { return }
            updateAppEnvironment()
            pri_save()
        }
    }

    var configEnvironment = ConfigEnvironment.test {
        didSet {
            guard configEnvironment != oldValue else { return }
            updateAppEnvironment()
            pri_save()
        }
    }

    var rpcUseOnlineUrl = false {
        didSet {
            guard rpcUseOnlineUrl != oldValue else { return }
            updateAppEnvironment()
            pri_save()
        }
    }

    var rpcCustomUrl = "" {
        didSet {
            guard rpcCustomUrl != oldValue else { return }
            updateAppEnvironment()
            pri_save()
        }
    }

    var showStatisticsToast = false {
        didSet {
            guard showStatisticsToast != oldValue else { return }
            pri_save()
        }
    }

    var reportEventInDebug = false {
        didSet {
            guard reportEventInDebug != oldValue else { return }
            pri_save()
        }
    }

    required init?(map: Map) {}

    func mapping(map: Map) {
        appEnvironment <- map["appEnvironment"]
        useBigDifficulty <- map["useBigDifficulty"]
        rpcUseOnlineUrl <- map["rpcUseOnlineUrl"]
        rpcCustomUrl <- map["rpcCustomUrl"]
        configEnvironment <- map["configEnvironment"]
        showStatisticsToast <- map["showStatisticsToast"]
        reportEventInDebug <- map["reportEventInDebug"]
    }

    private init() {

        if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let d = DebugService(JSONString: jsonString) {
            self.appEnvironment = d.appEnvironment
            self.useBigDifficulty = d.useBigDifficulty
            self.rpcUseOnlineUrl = d.rpcUseOnlineUrl
            self.rpcCustomUrl = d.rpcCustomUrl
            self.configEnvironment = d.configEnvironment
            self.showStatisticsToast = d.showStatisticsToast
            self.reportEventInDebug = d.reportEventInDebug
        }
    }

    fileprivate func pri_save() {
        if let data = self.toJSONString()?.data(using: .utf8) {
            if let error = fileHelper.writeData(data, relativePath: type(of: self).saveKey) {
                assert(false, error.localizedDescription)
            }
        }
    }
}
