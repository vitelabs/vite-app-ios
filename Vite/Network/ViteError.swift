//
//  ViteError.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit

extension Error {

    var code: ViteErrorCode {
        if let error = self as? ViteError {
            return error.code
        } else {
            return ViteErrorCode(type: .unknown, id: (self as NSError).code)
        }
    }

    // show in UI
    var message: String {
        if let error = self as? ViteError {
            return error.message
        } else {
            return (self as NSError).localizedDescription
        }
    }

    // print in log
    var rawMessage: String {
        if let error = self as? ViteError {
            return error.rawMessage
        } else {
            return message
        }
    }
}

struct ViteError: Error {

    let code: ViteErrorCode
    let message: String
    let rawMessage: String
    let rawError: Error?

    init(code: ViteErrorCode, message: String, rawError: Error?) {
        self.code = code
        self.message = type(of: self).assemblyMessage(code: code, message: message)
        self.rawMessage = type(of: self).assemblyRawMessage(code: code, message: message)
        self.rawError = rawError
    }

    fileprivate static func assemblyRawMessage(code: ViteErrorCode, message: String) -> String {
        return "\(message)(\(code.toString()))"
    }

    fileprivate static func assemblyMessage(code: ViteErrorCode, message: String) -> String {
        var ret = message
        if let str = code2MessageMap[code] {
            ret = str
        } else {
            switch code.type {
            case .st_con, .st_req, .st_res:
                ret = "\(R.string.localizable.viteErrorNetworkError())(\(code.toString()))"
            default:
                ret = "\(R.string.localizable.viteErrorOperationFailure())(\(code.toString()))"
            }
        }
        return ret
    }

    static let code2MessageMap: [ViteErrorCode: String] = [
        ViteErrorCode.rpcNotEnoughBalance: R.string.localizable.viteErrorRpcErrorCodeNotEnoughBalance(),
        ViteErrorCode.rpcNotEnoughQuota: R.string.localizable.viteErrorRpcErrorCodeNotEnoughQuota(),
        ViteErrorCode.rpcIdConflict: R.string.localizable.viteErrorRpcErrorCodeIdConflict(),
        ViteErrorCode.rpcContractDataIllegal: R.string.localizable.viteErrorRpcErrorCodeContractDataIllegal(),
        ViteErrorCode.rpcRefrenceSameSnapshootBlock: R.string.localizable.viteErrorRpcErrorCodeRefrenceSameSnapshootBlock(),
        ViteErrorCode.rpcContractMethodNotExist: R.string.localizable.viteErrorRpcErrorCodeContractMethodNotExist(),
        ViteErrorCode.rpcNoTransactionBefore: R.string.localizable.viteErrorRpcErrorCodeNoTransactionBefore(),
        ViteErrorCode.rpcHashVerifyFailure: R.string.localizable.viteErrorRpcErrorCodeHashVerifyFailure(),
        ViteErrorCode.rpcSignatureVerifyFailure: R.string.localizable.viteErrorRpcErrorCodeSignatureVerifyFailure(),
        ViteErrorCode.rpcPowNonceVerifyFailure: R.string.localizable.viteErrorRpcErrorCodePowNonceVerifyFailure(),
        ViteErrorCode.rpcRefrenceSnapshootBlockIllegal: R.string.localizable.viteErrorRpcErrorCodeRefrenceSnapshootBlockIllegal(),
    ]
}
