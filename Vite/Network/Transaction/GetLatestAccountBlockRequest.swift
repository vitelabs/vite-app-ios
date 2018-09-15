//
//  GetLatestAccountBlockRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

struct GetLatestAccountBlockRequest: JSONRPCKit.Request {
    typealias Response = AccountBlock

    let address: String

    var method: String {
        return "ledger_getLatestBlock"
    }

    var parameters: Any? {
        return [address]
    }

    init(address: String) {
        self.address = address
    }

    func response(from resultObject: Any) throws -> Response {
        if let _ = resultObject as? NSNull {
            return AccountBlock(address: self.address)
        } else if let response = resultObject as? [String: Any] {
            if let ret = AccountBlock(JSON: response) {
                return ret
            } else {
                throw JSONError.jsonData
            }
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
