//
//  GetFittestSnapshotHashRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import JSONRPCKit

class GetFittestSnapshotHashRequest: JSONRPCKit.Request {
    typealias Response = String

    let address: String
    let sendAccountBlockHash: String?

    var method: String {
        return "ledger_getFittestSnapshotHash"
    }

    var parameters: Any? {
        if let hash = sendAccountBlockHash {
            return [address, hash]
        } else {
            return [address]
        }
    }

    init(address: String, sendAccountBlockHash: String? = nil) {
        self.address = address
        self.sendAccountBlockHash = sendAccountBlockHash
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw ViteError.JSONTypeError()
        }
    }
}
