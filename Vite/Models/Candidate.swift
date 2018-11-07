//
//  Candidate.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

struct Candidate: Mappable {

    init?(map: Map) {

    }

    var name: String = ""
    var nodeAddr: String = ""
    var voteNum: String = ""

    mutating func mapping(map: Map) {
        name <- map["name"]
        nodeAddr <- map["nodeAddr"]
        voteNum <- map["voteNum"]
    }

}
