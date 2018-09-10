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

    fileprivate var tokenId = ""
    fileprivate var tokenName = ""
    fileprivate var tokenSymbol = ""

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        tokenId <- map["TokenTypeId"]
        tokenName <- map["TokenName"]
        tokenSymbol <- map["TokenSymbol"]
        unconfirmedBalance <- (map["Balance"], JSONTransformer.balance)
        unconfirmedCount <- map["UnconfirmedCount"]
        token = Token(id: tokenId, name: tokenName, symbol: tokenSymbol)
    }
}
