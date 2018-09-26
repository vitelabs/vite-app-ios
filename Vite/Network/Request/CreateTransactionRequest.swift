//
//  CreateTransactionRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

struct CreateTransactionRequest: JSONRPCKit.Request {
    typealias Response = NSNull

    let accountBlock: AccountBlock

    var method: String {
        return "ledger_sendTx"
    }

    var parameters: Any? {
        return [accountBlock.toJSON()]
    }

    init(accountBlock: AccountBlock) {
        self.accountBlock = accountBlock
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
