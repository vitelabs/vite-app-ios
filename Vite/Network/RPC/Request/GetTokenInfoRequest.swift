//
//  GetTokenInfoRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

class GetTokenInfoRequest: JSONRPCKit.Request {
    typealias Response = Token?

    let tokenId: String

    var method: String {
        return "ledger_getTokenMintage"
    }

    var parameters: Any? {
        return [tokenId]
    }

    init(tokenId: String) {
        self.tokenId = tokenId
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [String: Any] {
            if let ret = Token(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError()
            }
        } else if resultObject is NSNull {
            return nil
        } else {
            throw ViteError.JSONTypeError()
        }
    }
}
