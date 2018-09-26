//
//  GetUnconfirmedTransactionRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

struct GetUnconfirmedTransactionRequest: JSONRPCKit.Request {
    typealias Response = [AccountBlock]

    let address: String

    var method: String {
        return "ledger_getUnconfirmedBlocksByAccAddr"
    }

    var parameters: Any? {
        return [address, 0, 1]
    }

    init(address: String) {
        self.address = address
    }

    func response(from resultObject: Any) throws -> Response {
        var response = [[String: Any]]()
        if let object = resultObject as? [[String: Any]] {
            response = object
        }

        let block = response.map({ AccountBlock(JSON: $0) })
        let ret = block.compactMap { $0 }
        return ret
    }
}
