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

    fileprivate let appConfigHash: String?

    private init() {
        if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let config = AppConfig(JSONString: jsonString) {
            appConfigHash = jsonString.md5()
            configBehaviorRelay = BehaviorRelay(value: config)
        } else if let config: AppConfig = Bundle.getObject(forResource: type(of: self).saveKey) {
            appConfigHash = nil
            configBehaviorRelay = BehaviorRelay(value: config)
        } else {
            fatalError("app file not found in bundle")
        }
    }

    func start() {
        getConfigHash()
    }

    fileprivate func getConfigHash() {
        COSProvider.instance.getConfigHash { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let jsonString):
                plog(level: .debug, log: "get config hash finished", tag: .getConfig)
                guard let string = jsonString else { return }
                guard let configHash = ConfigHash(JSONString: string) else { return }
                self.getAppSettingsConfig(hash: configHash.appConfig)
                LocalizationService.sharedInstance.updateLocalizableIfNeeded(localizationHash: configHash.localization)
            case .failure(let error):
                plog(level: .warning, log: error.message, tag: .getConfig)
                GCD.delay(2, task: { self.getConfigHash() })
            }
        }
    }

    fileprivate func getAppSettingsConfig(hash: String?) {
        guard let hash = hash, hash != appConfigHash else { return }

        COSProvider.instance.getAppConfig { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let jsonString):
                plog(level: .debug, log: "get app config finished", tag: .getConfig)
                guard let string = jsonString else { return }
                plog(level: .debug, log: "md5: \(string.md5())", tag: .getConfig)
                if let data = string.data(using: .utf8) {
                    if let error = self.fileHelper.writeData(data, relativePath: type(of: self).saveKey) {
                        assert(false, error.localizedDescription)
                    }
                }

                if let config = AppConfig(JSONString: string) {
                    self.configBehaviorRelay.accept(config)
                }

            case .failure(let error):
                plog(level: .warning, log: error.message, tag: .getConfig)
                GCD.delay(2, task: { self.getAppSettingsConfig(hash: hash) })
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

    struct ConfigHash: Mappable {
        fileprivate(set) var appConfig: String?
        fileprivate(set) var localization: [String: Any] = [:]

        init?(map: Map) { }

        mutating func mapping(map: Map) {
            appConfig <- map["AppConfig"]
            localization <- map["Localization"]
        }
    }
}
