//
//  AppConfigVM.swift
//  Vite
//
//  Created by Water on 2018/9/28.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Moya
import SwiftyJSON

class AppConfigVM: NSObject {
    public func fetchVersionInfo() {
        let policies: [String: ServerTrustPolicy] = [:]
        let manager = Manager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
        )
        let provider =  MoyaProvider<ViteAPI>(manager: manager)

        let viteAppServiceRequest = ViteAppServiceRequest.init(provider: provider)

        let _ = viteAppServiceRequest.getAppSystemManageConfig().done { versions in
            guard let version = versions.first else { return }
            let dic = JSON.init(parseJSON: version)

            if dic.dictionaryValue.isEmpty {
                UserDefaults.standard.set(false, forKey: UserDefaultsName.isOpenFetchGift)
                UserDefaults.standard.synchronize()
            } else {
                let isOpen  = dic["isOpen"].boolValue
                if isOpen {
                    let isOpenFetchGift = dic["settingConfig"].dictionaryValue["isOpenFetchGift"]?.boolValue ?? true
                    UserDefaults.standard.set(isOpenFetchGift, forKey: UserDefaultsName.isOpenFetchGift)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.set(false, forKey: UserDefaultsName.isOpenFetchGift)
                    UserDefaults.standard.synchronize()
                }
            }
        }
        }
}
