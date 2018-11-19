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

    var name: String = ""
    var nodeAddr: Address = Address()
    var voteNum: VoteNum = VoteNum()

    func mapping(map: Map) {
        name <- map["name"]
        nodeAddr <- (map["nodeAddr"], JSONTransformer.address)
        voteNum <- (map["voteNum"], JSONTransformer.balance)
    }
}
