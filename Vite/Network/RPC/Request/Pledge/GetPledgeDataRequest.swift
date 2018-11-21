//
//  GetPledgeDataRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

class GetPledgeDataRequest: JSONRPCKit.Request {
    typealias Response = String

    let beneficialAddress: String

    var method: String {
        return "pledge_getPledgeData"
    }

    var parameters: Any? {
        return [beneficialAddress]
    }

    init(beneficialAddress: String) {
        self.beneficialAddress = beneficialAddress
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw ViteError.JSONTypeError()
        }
    }
}
