//
//  ViteAppServiceRequest.swift
//  Vite
//
//  Created by Water on 2018/9/27.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import PromiseKit
import Moya
import APIKit
import Result
import SwiftyJSON

import enum Result.Result

protocol ViteNetworkProtocol {
    var provider: MoyaProvider<ViteAPI> { get }
}

enum ViteAppServiceProtocolError: LocalizedError {
    case missingContractInfo
}

protocol NetworkProtocol: ViteNetworkProtocol {
    func getAppSystemManageConfig() -> Promise<[String]>
    func getAppUpdate() -> Promise<[String]>
}

final class ViteAppServiceRequest: NetworkProtocol {
    let provider: MoyaProvider<ViteAPI>
    let appBasicInfo = ["version": Bundle.main.buildNumber ?? "1.0",
        "app":"iphone"]

    init(
        provider: MoyaProvider<ViteAPI>
        ) {
        self.provider = provider
    }

    func getAppSystemManageConfig() -> Promise<[String]> {
        return Promise { seal in
            provider.request(.getAppSystemManageConfig(appBasicInfo)) { result in
                switch result {
                case .success(let response):
                    do {
                        print("response =============\(response)")

                        let data = try? response.mapJSON()
                        let json = JSON(data!)
                        let dic = json["data"].dictionaryValue

                        seal.fulfill([dic["name"]?.stringValue ?? "" ])
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func getAppUpdate() -> Promise<[String]> {
        return Promise { seal in
            provider.request(.getAppUpdate(appBasicInfo)) { result in
                switch result {
                case .success(let response):
                    do {
                        print("response \(response)")
                        //                        let items = try response.map(ArrayResponse<TokenObjectList>.self).docs
                        //                        let tokens = items.map { $0.contract }
                        //                        seal.fulfill(tokens)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }








}
