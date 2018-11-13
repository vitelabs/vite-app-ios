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

    fileprivate(set) var nodeName: String?
    fileprivate(set) var nodeStatus: NodeStatus?
    fileprivate(set) var balance: Balance?

    init(_ nodeName: String? = "", _ nodeStatus: NodeStatus? = .valid, _ balance: Balance? = nil) {
        self.nodeName = nodeName
        self.nodeStatus = nodeStatus
        self.balance = balance
    }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        nodeName <- (map["nodeName"])
        nodeStatus <- (map["nodeStatus"])
        balance <- (map["balance"], JSONTransformer.balance)
    }
}
