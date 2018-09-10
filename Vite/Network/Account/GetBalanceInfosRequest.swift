//
//  GetBalanceInfosRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

class GetBalanceInfosRequest: JSONRPCKit.Request {
    typealias Response = [BalanceInfo]

    let address: String

    var method: String {
        return "ledger_getAccountByAccAddr"
    }

    var parameters: Any? {
        return [address]
    }

    init(address: String) {
        self.address = address
    }

    func response(from resultObject: Any) throws -> [BalanceInfo] {
        if let response = resultObject as? [String: Any], let balanceInfoArray = response["BalanceInfos"] as? [[String: Any]] {
            let balanceInfos = balanceInfoArray.map({ BalanceInfo(JSON: $0) })
            let ret = balanceInfos.compactMap { $0 }
            return ret
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: [BalanceInfo].self)
        }
    }
}
