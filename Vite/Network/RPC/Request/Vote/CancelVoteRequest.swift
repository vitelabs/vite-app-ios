//
//  CancelVoteRequest.swift
//  Vite
//
//  Created by Water on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

struct CancelVoteRequest: JSONRPCKit.Request {
    typealias Response = String
    let gid: String

    var method: String {
        return "vote_getCancelVoteData"
    }

    var parameters: Any? {
        return [gid]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
