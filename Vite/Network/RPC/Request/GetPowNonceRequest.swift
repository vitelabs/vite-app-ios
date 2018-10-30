//
//  GetPowNonceRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import BigInt
import JSONRPCKit
import Vite_HDWalletKit

struct GetPowNonceRequest: JSONRPCKit.Request {
    typealias Response = String

    let difficulty: BigInt
    let address: Address
    let preHash: String?

    var method: String {
        return "pow_getPowNonce"
    }

    var parameters: Any? {
        let preHash = self.preHash ?? AccountBlock.Const.defaultHash
        let text = address.raw + preHash
        let data: String = Blake2b.hash(outLength: 32, in: text.bytes)?.toHexString() ?? ""
        return [String(difficulty), data]
    }

    init(address: Address, preHash: String?, difficulty: BigInt) {
        self.address = address
        self.preHash = preHash
        self.difficulty = difficulty
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let nonce = Data(base64Encoded: response)?.toHexString() {
            return nonce
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
