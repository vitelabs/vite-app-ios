//
//  GetVoteDataRequest.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

struct GetVoteDataRequest: JSONRPCKit.Request {
    typealias Response = String

    let gid: String
    let name: String

    var method: String {
        return "vote_getVoteData"
    }

    var parameters: Any? {
        return [gid, name]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
