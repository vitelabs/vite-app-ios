//
//  GetTransactionsRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

struct GetTransactionsRequest: JSONRPCKit.Request {
    typealias Response = (transactions: [Transaction], hasMore: Bool)

    let address: String
    let index: Int
    let count: Int

    var method: String {
        return "ledger_getBlocksByAccAddr"
    }

    var parameters: Any? {
        return [address, index, count + 1]
    }

    init(address: String, index: Int = 0, count: Int) {
        self.address = address
        self.index = index
        self.count = count
    }

    func response(from resultObject: Any) throws -> Response {
        var response = [[String: Any]]()
        if let object = resultObject as? [[String: Any]] {
            response = object
        }

        let transactions = response.map({ Transaction(JSON: $0) })
        let ret = transactions.compactMap { $0 }

        if ret.count > count {
            return (Array(ret.dropLast()), true)
        } else {
            return (ret, false)
        }
    }
}
