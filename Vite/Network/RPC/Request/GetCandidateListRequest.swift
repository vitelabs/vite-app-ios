//
//  GetVoteInfoRequest.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

struct GetCandidateListRequest: JSONRPCKit.Request {
    typealias Response = [Candidate]

    let gid: String

    var method: String {
        return "register_getCandidateList"
    }

    var parameters: Any? {
        return [gid]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [[String: String]] {
            let a = response.map { Candidate(JSON: $0) }
            return a.compactMap({ $0 })
        } else {
            throw RPCError.responseTypeNotMatch(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
