//
//  GetVoteInfoRequest.swift
//  Vite
//
//  Created by Water on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

struct GetVoteInfoRequest: JSONRPCKit.Request {
    typealias Response = VoteInfo?
    let gid: String
    let address: String

    var method: String {
        return "vote_getVoteInfo"
    }

    var parameters: Any? {
        return [gid, address]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [String: Any] {
            if let ret = VoteInfo(JSON: response) {
                return ret
            } else {
                throw JSONError.jsonData
            }
        } else if  let _ = resultObject as? NSNull {
            return nil
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
