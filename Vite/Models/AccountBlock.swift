//
//  AccountBlock.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import ObjectMapper
import BigInt

struct AccountBlock: Mappable {

    fileprivate(set) var meta = AccountBlockMeta()
    fileprivate(set) var accountAddress = ""
    fileprivate(set) var publicKey = ""
    fileprivate(set) var to = ""
    fileprivate(set) var from = ""
    fileprivate(set) var fromHash = ""
    fileprivate(set) var prevHash = ""
    fileprivate(set) var hash = ""
    fileprivate(set) var balance = BigInt(0)
    fileprivate(set) var amount = BigInt(0)
    fileprivate(set) var timestamp = Date()
    fileprivate(set) var tokenId = ""
    fileprivate(set) var lastBlockHeightInToken = Date()
    fileprivate(set) var data = ""
    fileprivate(set) var snapshotTimestamp = ""
    fileprivate(set) var signature = ""
    fileprivate(set) var nonce = ""
    fileprivate(set) var difficulty = ""
    fileprivate(set) var confirmedTimes = BigInt(0)

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        meta <- map["Meta"]
        accountAddress <- map["AccountAddress"]
        publicKey <- map["PublicKey"]
        to <- map["To"]
        from <- map["From"]
        fromHash <- map["FromHash"]
        prevHash <- map["PrevHash"]
        hash <- map["Hash"]
        balance <- (map["Balance"], JSONTransformer.bigint)
        amount <- (map["Amount"], JSONTransformer.bigint)
        timestamp <- (map["Timestamp"], JSONTransformer.timestamp)
        tokenId <- map["TokenId"]
        lastBlockHeightInToken <- (map["LastBlockHeightInToken"], JSONTransformer.timestamp)
        data <- map["Data"]
        snapshotTimestamp <- map["SnapshotTimestamp"]
        signature <- map["Signature"]
        nonce <- map["Nonce"]
        difficulty <- map["Difficulty"]
        confirmedTimes <- (map["ConfirmedTimes"], JSONTransformer.bigint)

    }



}

