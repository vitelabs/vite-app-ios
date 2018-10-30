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

    enum TransactionType: Int {
        case request
        case response
    }

    fileprivate var blockType: AccountBlock.BlockType?
    fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    fileprivate(set) var fromAddress = Address()
    fileprivate(set) var toAddress = Address()
    fileprivate(set) var hash = ""
    fileprivate(set) var amount = Balance()
    fileprivate(set) var token = Token()

    var type: TransactionType {
        guard let blockType = blockType else {
            return .request
        }
        switch blockType {
        case .createSend, .send, .rewardSend:
            return .request
        case .receive, .receiveError:
            return .response
        }
    }

    init?(map: Map) {
        guard let type = map.JSON["blockType"] as? Int, let _ = AccountBlock.BlockType(rawValue: type) else {
            return nil
        }
    }

    mutating func mapping(map: Map) {
        blockType <- map["blockType"]
        timestamp <- (map["timestamp"], JSONTransformer.timestamp)
        fromAddress <- (map["fromAddress"], JSONTransformer.address)
        toAddress <- (map["toAddress"], JSONTransformer.address)
        hash <- map["hash"]
        amount <- (map["amount"], JSONTransformer.balance)
        token <- map["tokenInfo"]
    }
}
