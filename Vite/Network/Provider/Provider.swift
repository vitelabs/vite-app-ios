//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import APIKit
import JSONRPCKit

final class Provider {
    static let instance = Provider(server: RPCServer.shared)

    let server: RPCServer
    init(server: RPCServer) {
        self.server = server
    }

    struct NetworkError: Error {
        let code: Int?
        let message: String
        let rawError: Error

        init(code: Int?, message: String, rawError: Error) {
            self.code = code
            self.message = message
            self.rawError = rawError
        }
    }

    enum NetworkResult<T> {
        case success(T)
        case error(NetworkError)

        static func wrapError(_ error: Error) -> NetworkResult {
            if let (code, message, error) = isJSONRPCErrorResponseError(error) {
                return NetworkResult.error(NetworkError(code: code, message: "\(message)(\(code))", rawError: error))
            } else {
                return NetworkResult.error(NetworkError(code: nil, message: error.localizedDescription, rawError: error))
            }
        }

        static func isJSONRPCErrorResponseError(_ error: Error) -> (code: Int, message: String, error: Error)? {
            if let error = error as? APIKit.SessionTaskError {
                if case .responseError(let error) = error {
                    if let error = error as? JSONRPCError {
                        if case .responseError(let code, let message, _) = error {
                            return (code, message, error)
                        }
                    }
                }
            }
            return nil
        }
    }
}
