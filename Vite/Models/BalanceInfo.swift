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

    init?(map: Map) {

    }

    init(token: Token, balance: Balance, unconfirmedBalance: Balance, unconfirmedCount: Int) {
        self.token = token
        self.balance = balance
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }

    mutating func mapping(map: Map) {
        token <- map["mintage"]
        balance <- (map["balance"], JSONTransformer.balance)
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

    static let defaultBalanceInfos: [BalanceInfo] = TokenCacheService.instance.defaultTokens.map {
        BalanceInfo(token: $0, balance: Balance(), unconfirmedBalance: Balance(), unconfirmedCount: 0)
    }

    static func mergeBalanceInfos(_ balanceInfos: [BalanceInfo]) -> [BalanceInfo] {
        let infos = NSMutableArray(array: balanceInfos)
        let ret = NSMutableArray()

        for defaultBalanceInfo in defaultBalanceInfos {
            if let index = (infos as Array).index(where: { ($0 as! BalanceInfo).token.id == defaultBalanceInfo.token.id }) {
                ret.add(infos[index])
                infos.removeObject(at: index)
            } else {
                ret.add(defaultBalanceInfo)
            }
        }
        ret.addObjects(from: infos as! [Any])
        return ret as! [BalanceInfo]
    }

    static func mergeBalanceInfos(_ balanceInfos: [BalanceInfo], unConfirmedInfos: [UnConfirmedInfo]) -> [BalanceInfo] {
        let infos = NSMutableArray(array: balanceInfos)
        let ret = NSMutableArray()

        for unConfirmedInfo in unConfirmedInfos {
            if let index = (infos as Array).index(where: { ($0 as! BalanceInfo).token.id == unConfirmedInfo.token.id }) {
                var info = infos[index] as! BalanceInfo
                info.fill(unconfirmedBalance: unConfirmedInfo.unconfirmedBalance, unconfirmedCount: unConfirmedInfo.unconfirmedCount)
                ret.add(info)
                infos.removeObject(at: index)
            } else {
                let info = BalanceInfo(token: unConfirmedInfo.token, balance: Balance(value: BigInt(0)), unconfirmedBalance: unConfirmedInfo.unconfirmedBalance, unconfirmedCount: unConfirmedInfo.unconfirmedCount)
                ret.add(info)
            }
        }
        ret.addObjects(from: infos as! [Any])
        return ret as! [BalanceInfo]
    }
}
