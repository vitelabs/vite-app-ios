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

    var useBigDifficulty = false {
        didSet {
            guard useBigDifficulty != oldValue else { return }
            pri_save()
        }
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

    var configEnvironment = ConfigEnvironment.test {
        didSet {
            guard configEnvironment != oldValue else { return }
            pri_save()
        }
    }

    var rpcUseOnlineUrl = false {
        didSet {
            guard rpcUseOnlineUrl != oldValue else { return }
            pri_save()
        }
    }

    var rpcCustomUrl = "" {
        didSet {
            plog(level: .debug, log: self.rpcCustomUrl)
            guard rpcCustomUrl != oldValue else { return }
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
