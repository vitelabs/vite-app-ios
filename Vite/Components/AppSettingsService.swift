//
//  AppSettingsService.swift
//  Vite
//
//  Created by Stone on 2018/10/22.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import ObjectMapper

class AppSettingsService {
    static let instance = AppSettingsService()

    lazy var configDriver: Driver<AppConfig> = self.configBehaviorRelay.asDriver()
    fileprivate let configBehaviorRelay: BehaviorRelay<AppConfig>
    fileprivate let fileHelper = FileHelper(.library, appending: FileHelper.appPathComponent)
    fileprivate static let saveKey = "AppConfig"

    private init() {
        if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let config = AppConfig(JSONString: jsonString) {
            configBehaviorRelay = BehaviorRelay(value: config)
        } else if let config: AppConfig = Bundle.getObject(forResource: type(of: self).saveKey) {
            configBehaviorRelay = BehaviorRelay(value: config)
        } else {
            fatalError("app file not found in bundle")
        }
    }

    func start() {
        getAppSettingsConfig()
    }

    fileprivate func getAppSettingsConfig() {

        COSProvider.instance.getAppConfig { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let jsonString):
                plog(level: .debug, log: "get app config finished", tag: .getConfig)
                if let string = jsonString,
                    let config = AppConfig(JSONString: string) {
                    self.configBehaviorRelay.accept(config)
                    if let data = config.toJSONString()?.data(using: .utf8) {
                        if let error = self.fileHelper.writeData(data, relativePath: type(of: self).saveKey) {
                            assert(false, error.localizedDescription)
                        }
                    }
                }
            case .error(let error):
                plog(level: .warning, log: error.message, tag: .getConfig)
                GCD.delay(2, task: { self.getAppSettingsConfig() })
            }
        }
    }
}

extension AppSettingsService {

    struct AppConfig: Mappable {
        fileprivate(set) var myPage: [String: Any] = [:]
        fileprivate(set) var defaultTokens: [String: Any] = [:]

        init?(map: Map) { }

        mutating func mapping(map: Map) {
            myPage <- map["my_page"]
            defaultTokens <- map["default_tokens"]
        }
    }
}
