//
//  VoteInfo.swift
//  Vite
//
//  Created by Water on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

struct VoteInfo: Mappable {

    enum NodeStatus: Int {
        case valid = 1
        case invalid = 2

        var display: String {
            switch self {
            case .valid:
                return R.string.localizable.votePageNodeStatusValidTitle.key.localized()
            case .invalid:
                return R.string.localizable.votePageNodeStatusValidTitle.key.localized()
            }
        }
    }

     var nodeName: String?
 var nodeStatus: NodeStatus?
 var balance: Balance?
//    fileprivate(set) var nodeName: String?
//    fileprivate(set) var nodeStatus: NodeStatus?
//    fileprivate(set) var balance: Balance?

    init() {

    }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        nodeName <- (map["nodeName"])
        nodeStatus <- (map["nodeStatus"])
        balance <- (map["balance"], JSONTransformer.balance)
    }
}
