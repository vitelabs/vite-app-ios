//
//  GetTestTokenRequest.swift
//  Vite
//
//  Created by Stone on 2018/11/15.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

struct GetTestTokenRequest: JSONRPCKit.Request {

    typealias Response = String

    let address: String

    var method: String {
        return "testapi_getTestToken"
    }

    var parameters: Any? {
        return [address]
    }

    init(address: String) {
        self.address = address
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
