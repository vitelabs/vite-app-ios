//
//  GetPledgeQuotaRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

class GetPledgeQuotaRequest: JSONRPCKit.Request {
    typealias Response = (UInt64, UInt64)

    let address: String

    var method: String {
        return "pledge_getPledgeQuota"
    }

    var parameters: Any? {
        return [address]
    }

    init(address: String) {
        self.address = address
    }

    func response(from resultObject: Any) throws -> Response {

        guard let response = resultObject as? [String: Any] else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: [String: Any].self)
        }

        if let quotaString = response["quota"] as? String,
            let maxTxCountString = response["txNum"] as? String,
            let quota = UInt64(quotaString),
            let maxTxcount = UInt64(maxTxCountString) {
            return (quota, maxTxcount)
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }

    }
}
