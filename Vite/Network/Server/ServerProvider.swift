//
//  ServerProvider.swift
//  Vite
//
//  Created by Stone on 2018/10/22.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Moya
import SwiftyJSON
import ObjectMapper

class ServerProvider: MoyaProvider<ViteAPI> {

    static let instance = ServerProvider(manager: Manager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: [:])
    ))

    fileprivate static func responseToString(response: Response) -> String? {
        if let data = try? response.mapJSON(),
            let dic = JSON(data).dictionaryValue["data"] {
            return dic.stringValue
        } else {
            return nil
        }
    }
}

extension ServerProvider {
    func getAppUpdate(completion: @escaping (NetworkResult<AppUpdateInfo?>) -> Void) {
        request(.getAppUpdate) { (result) in
            switch result {
            case .success(let response):
                if let string = type(of: self).responseToString(response: response),
                    let info = AppUpdateInfo(JSONString: string) {
                    completion(NetworkResult.success(info))
                } else {
                    completion(NetworkResult.success(nil))
                }
            case .failure(let error):
                completion(NetworkResult.wrapError(error))
            }
        }
    }

    func getAppDefaultTokens(completion: @escaping (NetworkResult<String>) -> Void) {
        request(.getAppDefaultTokens) { (result) in
            switch result {
            case .success(let response):
                if let string = type(of: self).responseToString(response: response) {
                    completion(NetworkResult.success(string))
                } else {
                    completion(NetworkResult.wrapError(JSONError.jsonData))
                }
            case .failure(let error):
                completion(NetworkResult.wrapError(error))
            }
        }
    }

    func getAppSettingsConfig(completion: @escaping (NetworkResult<AppConfig?>) -> Void) {
        request(.getAppSettingsConfig) { (result) in
            switch result {
            case .success(let response):
                if let string = type(of: self).responseToString(response: response),
                    let appConfig = AppConfig(JSONString: string) {
                    completion(NetworkResult.success(appConfig))
                } else {
                    completion(NetworkResult.success(nil))
                }
            case .failure(let error):
                completion(NetworkResult.wrapError(error))
            }
        }
    }
}

extension ServerProvider {

    struct AppConfig: Mappable {
        fileprivate(set) var isOpen = false
        fileprivate(set) var giftToken: Token?

        init?(map: Map) { }

        mutating func mapping(map: Map) {
            isOpen <- map["isOpen"]
            giftToken <- map["settingConfig.fetchGiftToken"]
        }
    }

    struct AppUpdateInfo: Mappable {
        fileprivate(set) var isOpen = false
        fileprivate(set) var isForce = true

        fileprivate var urlString = ""

        fileprivate var en_title = ""
        fileprivate var en_message = ""

        fileprivate var cn_title = ""
        fileprivate var cn_message = ""

        init?(map: Map) {
            guard let version = map.JSON["version"] as? [String: Any],
                let urlString = version["url"] as? String,
                let _ = URL(string: urlString) else {
                    return nil
            }
        }

        mutating func mapping(map: Map) {
            isOpen <- map["isOpen"]
            isForce <- map["version.isForce"]
            urlString <- map["version.url"]

            en_title <- map["version.en.title"]
            en_message <- map["version.en.message"]

            cn_title <- map["version.zh-Hans.title"]
            cn_message <- map["version.zh-Hans.message"]
        }

        var url: URL {
            return URL(string: urlString)!
        }

        var title: String {
            return LocalizationService.sharedInstance.currentLanguage == .chinese ? cn_title : en_title
        }

        var message: String {
            return LocalizationService.sharedInstance.currentLanguage == .chinese ? cn_message : en_message
        }
    }

}
