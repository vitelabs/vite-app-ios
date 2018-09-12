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

    init(token: Token, balance: Balance, unconfirmedBalance: Balance, unconfirmedCount: Int) {
        self.token = token
        self.balance = balance
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }

    mutating func mapping(map: Map) {
        tokenId <- map["TokenTypeId"]
        tokenName <- map["TokenName"]
        tokenSymbol <- map["TokenSymbol"]
        balance <- (map["Balance"], JSONTransformer.balance)
        token = Token(id: tokenId, name: tokenName, symbol: tokenSymbol)
    }

    mutating func fill(unconfirmedBalance: Balance, unconfirmedCount: Int) {
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }
}

extension BalanceInfo: Equatable {
    static func == (lhs: BalanceInfo, rhs: BalanceInfo) -> Bool {
        return lhs.token.id == rhs.token.id
    }
}

extension BalanceInfo {

    static let defaultBalanceInfos: [BalanceInfo] = Token.defaultTokens.map {
        BalanceInfo(token: $0, balance: Balance(), unconfirmedBalance: Balance(), unconfirmedCount: 0)
    }

    static func mergeBalanceInfos(_ balanceInfos: [BalanceInfo]) -> [BalanceInfo] {
        let infos = NSMutableArray(array: balanceInfos)
        let ret = NSMutableArray()

        for defaultBalanceInfo in defaultBalanceInfos {
            if infos.contains(defaultBalanceInfo) {
                let index = infos.index(of: defaultBalanceInfo)
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
