//
//  NetworkResult.swift
//  Vite
//
//  Created by Stone on 2018/10/22.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import APIKit

enum NetworkResult<T> {
    case success(T)
    case error(Error)

    static func wrapError(_ error: Error) -> NetworkResult {
        if let error = error as? APIKit.SessionTaskError {
            switch error {
            case .connectionError(let e):
                var userInfo = e.userInfo
                userInfo[NSLocalizedDescriptionKey] = "\(R.string.localizable.netWorkError())(C\(e.code))"
                let error = NSError.init(domain: e.domain, code: e.code, userInfo: userInfo)
                return NetworkResult.error(error)
            case .requestError(let e):
                var userInfo = e.userInfo
                userInfo[NSLocalizedDescriptionKey] = "\(R.string.localizable.netWorkError())(S\(e.code))"
                let error = NSError.init(domain: e.domain, code: e.code, userInfo: userInfo)
                return NetworkResult.error(error)
            case .responseError(let e):
                var userInfo = e.userInfo
                userInfo[NSLocalizedDescriptionKey] = "\(R.string.localizable.netWorkError())(R\(e.code))"
                let error = NSError.init(domain: e.domain, code: e.code, userInfo: userInfo)
                return NetworkResult.error(error)
            }
        }
        return NetworkResult.error(error)
    }
}
