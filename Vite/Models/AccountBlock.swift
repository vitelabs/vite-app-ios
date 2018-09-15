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
import Vite_keystore
import libEd25519Blake2b
import CryptoSwift

//fileprivate(set) var meta = AccountBlockMeta()
//fileprivate(set) var accountAddress = ""
//fileprivate(set) var publicKey = ""
//fileprivate(set) var to = ""
//fileprivate(set) var from = ""
//fileprivate(set) var fromHash = ""
//fileprivate(set) var prevHash = ""
//fileprivate(set) var hash = ""
//fileprivate(set) var balance = BigInt(0)
//fileprivate(set) var amount = BigInt(0)
//// TODO: 确定类型 timestamp
//fileprivate(set) var timestamp = UInt64(0)
//fileprivate(set) var tokenId = ""
//fileprivate(set) var lastBlockHeightInToken = UInt64(0)
//fileprivate(set) var data = ""
//fileprivate(set) var snapshotTimestamp = ""
//fileprivate(set) var signature = ""
//fileprivate(set) var nonce = ""
//fileprivate(set) var difficulty = ""
//fileprivate(set) var confirmedTimes = BigInt(0)
//fileprivate(set) var fAmount = BigInt(0)

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
    // TODO: 确定类型 timestamp
    fileprivate(set) var timestamp = UInt64(0)
    fileprivate(set) var tokenId = ""
    fileprivate(set) var lastBlockHeightInToken = UInt64(0)
    fileprivate(set) var data = ""
    fileprivate(set) var snapshotTimestamp = ""
    fileprivate(set) var signature = ""
    fileprivate(set) var nonce = ""
    fileprivate(set) var difficulty = ""
    fileprivate(set) var confirmedTimes = BigInt(0)
    fileprivate(set) var fAmount = BigInt(0)

    init() {

    }

    init?(map: Map) {

    }

    init(address: String) {
        self.init()
        self.accountAddress = address
    }

    static var test: AccountBlock = {
        var a = AccountBlock()
        a.accountAddress = "vite_85ffbcd9fcd341838811fd96aae5f0b02e0ae141b4e70fcecb"
        a.fromHash = "2415413b0c4c73d2ff7c23be16a74cbc89a94f34b97bdf7db79de841a21d8033"
        a.prevHash = "6afb1e1bbe26a5ddc7aa658784f1eb58a278fbd31b06c3e6974a8cbf08e79073"
        a.snapshotTimestamp = "52893cb69d6aa6fd1938692cfb91c93a8602ffc41f518fc08444380ae51f6a56"
        a.meta.setHeight(BigInt(100))
        a.timestamp = 1537008137
        a.tokenId = "tti_000000000000000000004cfd"
        a.data = "12345"
        a.nonce = "0000000000"
        a.difficulty = "0000000000"
        a.fAmount = BigInt(0)
        let key = WalletDataService.shareInstance.defaultWalletAccount!.defaultKey
        let (hash, s) = signature(accountBlock: a, secretKeyHexString: key.secretKey, publicKeyHexString: key.publicKey)
        return a
    }()

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
        timestamp <- map["Timestamp"]
        tokenId <- map["TokenId"]
        lastBlockHeightInToken <- map["LastBlockHeightInToken"]
        data <- map["Data"]
        snapshotTimestamp <- map["SnapshotTimestamp"]
        signature <- map["Signature"]
        nonce <- map["Nonce"]
        difficulty <- map["Difficulty"]
        confirmedTimes <- (map["ConfirmedTimes"], JSONTransformer.bigint)

    }

    func makeReceiveAccountBlock(latestAccountBlock: AccountBlock, key: WalletAccount.Key) -> AccountBlock {
        var accountBlock = AccountBlock()
        accountBlock.meta.setHeight(latestAccountBlock.meta.height + 1)
        accountBlock.accountAddress = latestAccountBlock.accountAddress
        accountBlock.publicKey = key.publicKey
        accountBlock.to = ""
        accountBlock.from = ""
        accountBlock.fromHash = self.hash
        accountBlock.prevHash = latestAccountBlock.hash
        accountBlock.balance = BigInt(0)
        accountBlock.amount = BigInt(0)
        accountBlock.timestamp = UInt64(Date().timeIntervalSince1970)
        accountBlock.tokenId = self.tokenId
        accountBlock.lastBlockHeightInToken = UInt64(0)
        accountBlock.data = self.data
        // TODO: 先写死，之后从接口获取
        accountBlock.snapshotTimestamp = "52893cb69d6aa6fd1938692cfb91c93a8602ffc41f518fc08444380ae51f6a56"
        accountBlock.nonce = "0000000000"
        accountBlock.difficulty = "0000000000"
        accountBlock.confirmedTimes = BigInt(0)
        accountBlock.fAmount = BigInt(0)

        let (hash, signature) = AccountBlock.signature(accountBlock: accountBlock, secretKeyHexString: key.secretKey, publicKeyHexString: key.publicKey)

        accountBlock.hash = hash
        accountBlock.signature = signature

        return accountBlock
    }

    static func signature(accountBlock: AccountBlock, secretKeyHexString: String, publicKeyHexString: String) -> (hash: String, signature: String) {
        var source = Bytes()

        // Bytes->hex2Bytes
        // string->my_bytes

        if accountBlock.prevHash.isEmpty == false {
            source.append(contentsOf: accountBlock.prevHash.hex2Bytes)
        }

        // bytes 函数名冲突
        source.append(contentsOf: accountBlock.meta.height.description.my_bytes)
        // accountAddress 掐头去尾
        print(accountBlock.accountAddress.addressStrip)
        source.append(contentsOf: accountBlock.accountAddress.addressStrip.hex2Bytes)

        if accountBlock.to.isEmpty == false {
            // to 掐头去尾
            source.append(contentsOf: accountBlock.to.addressStrip.hex2Bytes)
            if accountBlock.tokenId.isEmpty == false {

                // tokenId 掐头去尾
                source.append(contentsOf: accountBlock.tokenId.tokenIdStrip.hex2Bytes)
            }
            source.append(contentsOf: accountBlock.amount.description.my_bytes)
        } else {
            source.append(contentsOf: accountBlock.fromHash.hex2Bytes)
        }
//        var bigEndian = accountBlock.timestamp.bigEndian
//        let data = Data(bytes: &bigEndian, count: MemoryLayout.size(ofValue: bigEndian))
//        var bytes = Bytes(data)

        // timestamp
        source.append(contentsOf: "EFBFBD".hex2Bytes)

        if accountBlock.data.isEmpty == false {
            source.append(contentsOf: accountBlock.data.my_bytes)
        }

        source.append(contentsOf: accountBlock.snapshotTimestamp.hex2Bytes)
        source.append(contentsOf: accountBlock.nonce.hex2Bytes)
        source.append(contentsOf: accountBlock.difficulty.hex2Bytes)

        source.append(contentsOf: accountBlock.fAmount.description.my_bytes)

        // 解包
        let hash = Blake2b.hash(outLength: 32, in: source)!

        print("😄")
        print(source.toHexString())
        print("😄")
        let hashret = hash.toHexString()
        let signature = Ed25519.sign(message: hash, secretKey: secretKeyHexString.hex2Bytes, publicKey: publicKeyHexString.hex2Bytes).toHexString()
        return (hashret, signature)
    }
}

extension String {
    public var my_bytes: Array<UInt8> {
        return data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
    }
}
