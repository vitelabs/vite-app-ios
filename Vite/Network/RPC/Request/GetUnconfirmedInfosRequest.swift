//
//  GetUnconfirmedInfoRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

class GetUnconfirmedInfosRequest: JSONRPCKit.Request {
    typealias Response = [UnConfirmedInfo]

    let address: String

    var method: String {
        return "onroad_getAccountOnroadInfo"
    }

    var parameters: Any? {
        return [address]
    }

    init(address: String) {
        self.address = address
    }

    func response(from resultObject: Any) throws -> [UnConfirmedInfo] {

        if let _ = resultObject as? NSNull {
            return []
        }

        guard let response = resultObject as? [String: Any] else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: [UnConfirmedInfo].self)
        }

        var unConfirmedInfoArray = [[String: Any]]()
        if let map = response["tokenBalanceInfoMap"] as?  [String: Any],
            let array = Array(map.values) as? [[String: Any]] {
            unConfirmedInfoArray = array
        }

        let unConfirmedInfos = unConfirmedInfoArray.map({ UnConfirmedInfo(JSON: $0) })
        let ret = unConfirmedInfos.compactMap { $0 }
        return ret
    }
}
