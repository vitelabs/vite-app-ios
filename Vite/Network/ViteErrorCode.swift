//
//  ViteErrorCode.swift
//  Vite
//
//  Created by Stone on 2018/11/20.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation

extension ViteErrorCode: Hashable {
    static func == (lhs: ViteErrorCode, rhs: ViteErrorCode) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }

    var hashValue: Int {
        return toString().hashValue
    }
}

extension ViteErrorCode: CustomStringConvertible, CustomDebugStringConvertible {

    func toString() -> String {
        return type.rawValue.uppercased().replacingOccurrences(of: "_", with: ".") + "." + String(id)
    }

    var description: String {
        return toString()
    }

    var debugDescription: String {
        return toString()
    }
}

struct ViteErrorCode {

    let type: CodeType
    let id: Int

    enum CodeType: String {

        // session task error
        case st_con         // connectionError
        case st_req         // requestError
        case st_res         // responseError

        // rpc error, in st_res error
        case rpc            // responseError
        case rpc_res_nf     // responseNotFound
        case rpc_ro_p       // resultObjectParseError
        case rpc_eo_p       // errorObjectParseError
        case rpc_u_v        // unsupportedVersion
        case rpc_u_t        // unexpectedTypeObject
        case rpc_m_re       // missingBothResultAndError
        case rpc_nar        // nonArrayResponse

        // json error
        case json_t_e       // json type error

        // unknown
        case unknown
    }

    // unknown error
    static let unknown = ViteErrorCode(type: .unknown, id: 0)

    // rpc error
    static let rpcNotEnoughBalance = ViteErrorCode(type: .rpc, id: -35001)
    static let rpcNotEnoughQuota = ViteErrorCode(type: .rpc, id: -35002)
    static let rpcNoTransactionBefore = ViteErrorCode(type: .rpc, id: -36001)
}

extension ViteError {
    static func JSONTypeError() -> ViteError {
        return ViteError(code: ViteErrorCode(type: .json_t_e, id: 0), message: "JSON Type Error", rawError: nil)
    }
}
