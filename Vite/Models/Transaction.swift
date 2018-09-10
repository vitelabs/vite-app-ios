//
//  Transaction.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

struct Transaction: Equatable, Mappable {

    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.hash == rhs.hash
    }

    enum Status: Int {
        case error = 0
        case waitResponse = 1
        case finished = 2
    }

    fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    fileprivate(set) var fromAddress = Address()
    fileprivate(set) var toAddress = Address()
    fileprivate(set) var status = Status.error
    fileprivate(set) var hash = ""
    fileprivate(set) var balance = Balance()
    fileprivate(set) var amount = Balance()
    fileprivate(set) var confirmedTimes = ""

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        timestamp <- (map["Timestamp"], JSONTransformer.timestamp)
        fromAddress <- (map["FromAddr"], JSONTransformer.address)
        toAddress <- (map["ToAddr"], JSONTransformer.address)
        status <- map["Status"]
        hash <- map["Hash"]
        balance <- (map["Balance"], JSONTransformer.balance)
        amount <- (map["Amount"], JSONTransformer.balance)
        confirmedTimes <- map["ConfirmedTimes"]
    }
}
