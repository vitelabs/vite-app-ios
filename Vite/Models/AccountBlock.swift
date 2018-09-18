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
import libEd25519Blake2b
import CryptoSwift

struct AccountBlock: Mappable {

    fileprivate(set) var meta = AccountBlockMeta()
    fileprivate(set) var accountAddress: Address?
    fileprivate(set) var publicKey: String?
    fileprivate(set) var to: Address?
    fileprivate(set) var from: Address?
    fileprivate(set) var fromHash: String?
    fileprivate(set) var prevHash: String?
    fileprivate(set) var hash: String?
    fileprivate(set) var balance: BigInt?
    fileprivate(set) var amount: BigInt?
    fileprivate(set) var timestamp: BigInt?
    fileprivate(set) var tokenId: String?
    fileprivate(set) var lastBlockHeightInToken: BigInt?
    fileprivate(set) var data: String?
    fileprivate(set) var snapshotChainHash: String?
    fileprivate(set) var signature: String?
    fileprivate(set) var nonce: String?
    fileprivate(set) var difficulty: String?
    fileprivate(set) var confirmedTimes: BigInt?
    fileprivate(set) var fAmount: BigInt?

    init() {

    }

    init?(map: Map) {

    }

    init(address: Address) {
        self.init()
        self.accountAddress = address
    }

    mutating func mapping(map: Map) {

        meta <- map["meta"]
        accountAddress <- (map["accountAddress"], JSONTransformer.address)
        publicKey <- map["publicKey"]
        to <- (map["to"], JSONTransformer.address)
        from <- (map["from"], JSONTransformer.address)
        fromHash <- map["fromHash"]
        prevHash <- map["prevHash"]
        hash <- map["hash"]
        balance <- (map["balance"], JSONTransformer.bigint)
        amount <- (map["amount"], JSONTransformer.bigint)
        timestamp <- map["timestamp"]
        tokenId <- map["tokenId"]
        lastBlockHeightInToken <- (map["lastBlockHeightInToken"], JSONTransformer.bigint)
        data <- map["data"]
        snapshotChainHash <- map["snapshotTimestamp"]
        signature <- map["signature"]
        nonce <- map["nonce"]
        difficulty <- map["difficulty"]
        confirmedTimes <- (map["confirmedTimes"], JSONTransformer.bigint)
        fAmount <- (map["fAmount"], JSONTransformer.bigint)
    }
}

extension AccountBlock {

    static func makeSendAccountBlock(latest: AccountBlock,
                                     bag: HDWalletManager.Bag,
                                     snapshotChainHash: String,
                                     toAddress: Address,
                                     tokenId: String,
                                     amount: BigInt,
                                     data: String?) -> AccountBlock {
        var block = makeBaseAccountBlock(latest: latest, bag: bag, snapshotChainHash: snapshotChainHash)

        block.data = data
        block.tokenId = tokenId

        block.to = toAddress
        block.amount = amount

        let (hash, signature) = sign(accountBlock: block,
                                     secretKeyHexString: bag.secretKey,
                                     publicKeyHexString: bag.publicKey)
        block.hash = hash
        block.signature = signature

        return block
    }

    static func makeReceiveAccountBlock(unconfirmed: AccountBlock,
                                        latest: AccountBlock,
                                        bag: HDWalletManager.Bag,
                                        snapshotChainHash: String) -> AccountBlock {
        var block = makeBaseAccountBlock(latest: latest, bag: bag, snapshotChainHash: snapshotChainHash)

        block.data = unconfirmed.data
        block.tokenId = unconfirmed.tokenId

        block.fromHash = unconfirmed.hash

        let (hash, signature) = sign(accountBlock: block,
                                     secretKeyHexString: bag.secretKey,
                                     publicKeyHexString: bag.publicKey)
        block.hash = hash
        block.signature = signature

        return block
    }

    static func makeBaseAccountBlock(latest: AccountBlock,
                                             bag: HDWalletManager.Bag,
                                             snapshotChainHash: String) -> AccountBlock {
        var block = AccountBlock()

        if let height = latest.meta.height {
            block.meta.setHeight(height + 1)
        } else {
            block.meta.setHeight(1)
        }

        block.accountAddress = bag.address
        block.publicKey = bag.publicKey
        block.prevHash = latest.hash
        block.timestamp = BigInt(Date().timeIntervalSince1970)
        block.snapshotChainHash = snapshotChainHash
        block.nonce = "0000000000"
        block.difficulty = "0000000000"
        block.fAmount = BigInt(0)

        return block
    }

    private static func sign(accountBlock: AccountBlock,
                             secretKeyHexString: String,
                             publicKeyHexString: String) -> (hash: String, signature: String) {
        var source = Bytes()

        // Bytes->hex2Bytes
        // string->bytes

        if let prevHash = accountBlock.prevHash {
            source.append(contentsOf: prevHash.hex2Bytes)
        }

        if let height = accountBlock.meta.height {
            // bytes 函数名冲突
            source.append(contentsOf: height.description.bytes)
        }

        if let accountAddress = accountBlock.accountAddress {
            source.append(contentsOf: accountAddress.raw.hex2Bytes)
        }

        if let to = accountBlock.to {
            source.append(contentsOf: to.raw.hex2Bytes)
            if let tokenId = accountBlock.tokenId {
                source.append(contentsOf: Token.idStriped(tokenId).hex2Bytes)
            }
            if let amount = accountBlock.amount {
                source.append(contentsOf: amount.description.bytes)
            }
        } else {
            if let fromHash = accountBlock.fromHash {
                source.append(contentsOf: fromHash.hex2Bytes)
            }
        }

        // timestamp: The Magic Number
        source.append(contentsOf: "EFBFBD".hex2Bytes)

        if let data = accountBlock.data {
            source.append(contentsOf: data.bytes)
        }

        if let snapshotChainHash = accountBlock.snapshotChainHash {
            source.append(contentsOf: snapshotChainHash.hex2Bytes)
        }

        if let nonce = accountBlock.nonce {
            source.append(contentsOf: nonce.hex2Bytes)
        }

        if let difficulty = accountBlock.difficulty {
            source.append(contentsOf: difficulty.hex2Bytes)
        }

        if let fAmount = accountBlock.fAmount {
            source.append(contentsOf: fAmount.description.bytes)
        }

        let hash = Blake2b.hash(outLength: 32, in: source) ?? Bytes()
        let hashString = hash.toHexString()
        let signature = Ed25519.sign(message: hash, secretKey: secretKeyHexString.hex2Bytes, publicKey: publicKeyHexString.hex2Bytes).toHexString()
        return (hashString, signature)
    }
}
