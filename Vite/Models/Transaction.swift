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
        case register
        case registerUpdate
        case cancelRegister
        case extractReward
        case vote
        case cancelVote
        case pledge
        case cancelPledge
        case coin
        case cancelCoin
        case send
        case receive
    }

    fileprivate var blockType: AccountBlock.BlockType?
    fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    fileprivate(set) var fromAddress = Address()
    fileprivate(set) var toAddress = Address()
    fileprivate(set) var hash = ""
    fileprivate(set) var amount = Balance()
    fileprivate(set) var token = Token()
    fileprivate(set) var data: String?

    fileprivate static let transactionTypeDataPrefixMap: [String: TransactionType] = [
        "f29c6ce2": .register,
        "3b7bdf74": .registerUpdate,
        "60862fe2": .cancelRegister,
        "ce1f27a7": .extractReward,
        "fdc17f25": .vote,
        "a629c531": .cancelVote,
        "8de7dcfd": .pledge,
        "9ff9c7b6": .cancelPledge,
        "46d0ce8b": .coin,
        "9b9125f5": .cancelCoin,
        ]

    fileprivate static let transactionTypeToAddressMap: [TransactionType: String] = [
        .register: Provider.Const.ContractAddress.register.rawValue,
        .registerUpdate: Provider.Const.ContractAddress.register.rawValue,
        .cancelRegister: Provider.Const.ContractAddress.register.rawValue,
        .extractReward: Provider.Const.ContractAddress.register.rawValue,
        .vote: Provider.Const.ContractAddress.vote.rawValue,
        .cancelVote: Provider.Const.ContractAddress.vote.rawValue,
        .pledge: Provider.Const.ContractAddress.pledge.rawValue,
        .cancelPledge: Provider.Const.ContractAddress.pledge.rawValue,
        .coin: Provider.Const.ContractAddress.coin.rawValue,
        .cancelCoin: Provider.Const.ContractAddress.coin.rawValue,
        ]

    var type: TransactionType {
        guard let blockType = blockType else {
            return .receive
        }

        switch blockType {
        case .createSend, .rewardSend:
            return .send
        case .receiveError:
            return .receive
        case .send:
            guard let base64 = data, let string = Data(base64Encoded: base64)?.toHexString() else { return .send }
            guard string.count >= 8 else { return .send }
            let prefix = (string as NSString).substring(to: 8) as String
            if let type = Transaction.transactionTypeDataPrefixMap[prefix] {
                if Transaction.transactionTypeToAddressMap[type] == toAddress.description {
                    return type
                } else {
                    return .send
                }
            } else {
                return .send
            }
        case .receive:
            return .receive
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
        data <- map["data"]
    }
}
