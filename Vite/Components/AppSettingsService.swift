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

class AppSettingsService {
    static let instance = AppSettingsService()
    fileprivate static let saveKey = "AppSettings"

    let giftTokenBehaviorRelay: BehaviorRelay<Token?> = BehaviorRelay(value: nil)

    fileprivate enum Key: String {
        case collection = "AppSettings"
        case giftToken = "GiftToken"
    }

    private init() {
        if let string = UserDefaultsService.instance.objectForKey(Key.giftToken.rawValue, inCollection: Key.collection.rawValue) as? String,
            let token = Token(JSONString: string) {
            giftTokenBehaviorRelay.accept(token)
        }
    }

    func start() {
        getAppSettingsConfig()
    }

    fileprivate func getAppSettingsConfig() {
        ServerProvider.instance.getAppSettingsConfig { (result) in
            switch result {
            case .success(let c):
                plog(level: .debug, log: "get app settings config finished", tag: .getConfig)
                guard let config = c else { return }
                var token = config.giftToken
                if !config.isOpen { token = nil }
                self.giftTokenBehaviorRelay.accept(token)
                UserDefaultsService.instance.setObject(token?.toJSONString() ?? "", forKey: Key.giftToken.rawValue, inCollection: Key.collection.rawValue)
            case .error(let error):
                plog(level: .warning, log: error.localizedDescription, tag: .getConfig)
                GCD.delay(2, task: {
                    self.getAppSettingsConfig()
                })
            }
        }
    }
}
