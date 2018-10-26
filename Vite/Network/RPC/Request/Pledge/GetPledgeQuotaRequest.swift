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
    typealias Response = (String, String)

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

        if let quota = response["quota"] as? String,
            let maxTxCount = response["txNum"] as? String {
            return (quota, maxTxCount)
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }

    }
}
