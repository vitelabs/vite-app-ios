//
//  UnConfirmedInfo.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

struct UnConfirmedInfo: Mappable {

    fileprivate(set) var token = Token()
    fileprivate(set) var unconfirmedBalance = Balance()
    fileprivate(set) var unconfirmedCount: Int = 0

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        token <- map["mintage"]
        unconfirmedBalance <- (map["balance"], JSONTransformer.balance)
        unconfirmedCount <- map["unconfirmedCount"]
    }
}
