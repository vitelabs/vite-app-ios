//
//  GetLatestSnapshotHashRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

class GetLatestSnapshotHashRequest: JSONRPCKit.Request {
    typealias Response = String

    var method: String {
        return "ledger_getLatestSnapshotChainHash"
    }

    var parameters: Any? {
        return []
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
