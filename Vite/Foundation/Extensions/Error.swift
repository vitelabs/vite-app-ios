//
//  Error.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit

extension Error {
    var code: Int {
        if let rpcError = self as? JSONRPCError {
            return rpcError.code
        } else {
            return (self as NSError).code
        }
    }

    var message: String {
        if let rpcError = self as? JSONRPCError {
            return rpcError.message
        } else {
            return (self as NSError).localizedDescription
        }
    }

    var domain: String { return (self as NSError).domain }
    var userInfo: [String: Any] { return (self as NSError).userInfo }
}

extension JSONRPCError {
    var code: Int {
        switch self {
        case .responseError(code: let c, message: _, data: _):
            return c
        case .resultObjectParseError(let e):
            return e.code
        case .errorObjectParseError(let e):
            return e.code
        case .responseNotFound(requestId: _, object: _),
             .unsupportedVersion,
             .unexpectedTypeObject,
             .missingBothResultAndError,
             .nonArrayResponse:
            return (self as NSError).code
        }
    }

    var message: String {
        switch self {
        case .responseError(code: _, message: let m, data: _):
            return m
        case .resultObjectParseError(let e):
            return e.localizedDescription
        case .errorObjectParseError(let e):
            return e.localizedDescription
        case .responseNotFound(requestId: _, object: _),
             .unsupportedVersion,
             .unexpectedTypeObject,
             .missingBothResultAndError,
             .nonArrayResponse:
            return (self as NSError).localizedDescription
        }
    }
}
