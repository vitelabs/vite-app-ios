//
//  COSProvider.swift
//  Vite
//
//  Created by Stone on 2018/11/5.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Moya
import SwiftyJSON
import ObjectMapper

class COSProvider: MoyaProvider<COSAPI> {
    static let instance = COSProvider(manager: Manager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: [:])
    ))
}

extension COSProvider {

    func getAppConfig(completion: @escaping (NetworkResult<String?>) -> Void) {
        request(.getAppConfig) { (result) in
            switch result {
            case .success(let response):
                if let string = try? response.mapString() {
                    completion(NetworkResult.success(string))
                } else {
                    completion(NetworkResult.success(nil))
                }
            case .failure(let error):
                completion(NetworkResult.wrapError(error))
            }
        }
    }

    func checkUpdate(completion: @escaping (NetworkResult<String?>) -> Void) {
        request(.checkUpdate) { (result) in
            switch result {
            case .success(let response):
                if let string = try? response.mapString() {
                    completion(NetworkResult.success(string))
                } else {
                    completion(NetworkResult.success(nil))
                }
            case .failure(let error):
                completion(NetworkResult.wrapError(error))
            }
        }
    }
}
