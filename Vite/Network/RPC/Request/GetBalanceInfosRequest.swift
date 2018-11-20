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

        if let _ = resultObject as? NSNull {
            return []
        }

        guard let response = resultObject as? [String: Any] else {
            throw ViteError.JSONTypeError()
        }

        var balanceInfoArray = [[String: Any]]()
        if let map = response["tokenBalanceInfoMap"] as?  [String: Any],
            let array = Array(map.values) as? [[String: Any]] {
            balanceInfoArray = array
        }

        let balanceInfos = balanceInfoArray.map({ BalanceInfo(JSON: $0) })
        let ret = balanceInfos.compactMap { $0 }
        return ret
    }
}
