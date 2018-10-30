//
//  GetSnapshotChainHeightRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

struct GetSnapshotChainHeightRequest: JSONRPCKit.Request {
    typealias Response = String

    var method: String {
        return "ledger_getSnapshotChainHeight"
    }

    var parameters: Any? {
        return nil
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
