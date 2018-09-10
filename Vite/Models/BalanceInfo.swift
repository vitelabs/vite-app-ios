//
//  BalanceInfo.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

struct BalanceInfo: Mappable {

    fileprivate(set) var token = Token()
    fileprivate(set) var balance = Balance()
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
        balance <- (map["Balance"], JSONTransformer.balance)
        token = Token(id: tokenId, name: tokenName, symbol: tokenSymbol)
    }
}
