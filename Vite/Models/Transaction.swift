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

    enum TransactionType: Int {
        case request
        case response
    }

    fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    fileprivate(set) var fromAddress = Address()
    fileprivate(set) var toAddress = Address()
    fileprivate(set) var hash = ""
    fileprivate(set) var balance = Balance()
    fileprivate(set) var amount = Balance()
    fileprivate(set) var tokenId = ""

    var type: TransactionType {
        return toAddress.isValid ? .request : .response
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        timestamp <- (map["Timestamp"], JSONTransformer.timestamp)
        fromAddress <- (map["From"], JSONTransformer.address)
        toAddress <- (map["To"], JSONTransformer.address)
        hash <- map["Hash"]
        balance <- (map["Balance"], JSONTransformer.balance)
        amount <- (map["Amount"], JSONTransformer.balance)
        tokenId <- map["TokenId"]
    }
}
