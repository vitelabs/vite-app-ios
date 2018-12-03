//
//  Candidate.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

typealias VoteNum = Balance

class Candidate: NSObject, Mappable {

    required init?(map: Map) {

    }

    fileprivate(set) var name: String = ""
    fileprivate(set) var nodeAddr: Address = Address()
    fileprivate(set) var voteNum: VoteNum = VoteNum()
    fileprivate(set) var rank: Int = 0

    func mapping(map: Map) {
        name <- map["name"]
        nodeAddr <- (map["nodeAddr"], JSONTransformer.address)
        voteNum <- (map["voteNum"], JSONTransformer.balance)
    }

    func updateRank(_ rank: Int) {
        self.rank = rank
    }
}
