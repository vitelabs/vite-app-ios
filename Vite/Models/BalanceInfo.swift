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

    fileprivate(set) var balance = Balance()
    fileprivate(set) var unconfirmedBalance = Balance()
    fileprivate(set) var unconfirmedCount: Int = 0

    fileprivate var tokenId = ""
    fileprivate var tokenName = ""
    fileprivate var tokenSymbol = ""

    var token: Token {
        return Token(id: tokenId, name: tokenName, symbol: tokenSymbol)
    }

    init?(map: Map) {

    }

    init(token: Token, balance: Balance, unconfirmedBalance: Balance, unconfirmedCount: Int) {
        self.balance = balance
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount

        self.tokenId = token.id
        self.tokenName = token.name
        self.tokenSymbol = token.symbol
    }

    mutating func mapping(map: Map) {
        tokenId <- map["TokenTypeId"]
        tokenName <- map["TokenName"]
        tokenSymbol <- map["TokenSymbol"]
        balance <- (map["Balance"], JSONTransformer.balance)
    }

    mutating func fill(unconfirmedBalance: Balance, unconfirmedCount: Int) {
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }
}

extension BalanceInfo: Equatable {
    static func == (lhs: BalanceInfo, rhs: BalanceInfo) -> Bool {
        return lhs.tokenId == rhs.tokenId
    }
}

extension BalanceInfo {

    static let defaultBalanceInfos: [BalanceInfo] = TokenCacheService.instance.defaultTokens.map {
        BalanceInfo(token: $0, balance: Balance(), unconfirmedBalance: Balance(), unconfirmedCount: 0)
    }

    static func mergeBalanceInfos(_ balanceInfos: [BalanceInfo]) -> [BalanceInfo] {
        let infos = NSMutableArray(array: balanceInfos)
        let ret = NSMutableArray()

        for defaultBalanceInfo in defaultBalanceInfos {
            if infos.contains(where: { ($0 as! BalanceInfo).tokenId == defaultBalanceInfo.tokenId }) {
                let index = (infos as Array).index(where: { ($0 as! BalanceInfo).tokenId == defaultBalanceInfo.tokenId })!
                ret.add(infos[index])
                infos.removeObject(at: index)
            } else {
                ret.add(defaultBalanceInfo)
            }
        }
        ret.addObjects(from: infos as! [Any])
        return ret as! [BalanceInfo]
    }
}
