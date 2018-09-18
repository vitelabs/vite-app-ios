//
//  ViteNetworkTests.swift
//  ViteTests
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import XCTest
import PromiseKit
import BigInt
import ObjectMapper
@testable import Vite

class ViteNetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func async(_ block: ( @escaping () -> () ) -> ()) {

        let expect = expectation(description: "method")
        block {
            expect.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
        print("🍺🍺🍺🍺🍺🍺")

    }

    func testSnapshotChainProvider() {

        async { (completion) in
            let provider = SnapshotChainProvider(server: RPCServer.shared)
            _ = provider.height()
                .done { height in
                    print("🏆snapschot china height: \(height)")
                }.catch({ (error) in
                    print("🤯🤯🤯🤯🤯🤯\(error)")
                }).finally {
                    completion()
            }
        }

    }

    func testAccountProvider_GetTransactionsRequest() {
        async { (completion) in
            let accountProvider = AccountProvider(server: RPCServer.shared)
            _ = accountProvider.getTransactions(address: Address(string: "vite_7945df07bbf55f5afc76360a263b0870795ce5d1ecea36b786"), count: 5).done { transactions in
                print("🏆\(transactions)")
                completion()
            }
        }

    }

    func testAccountProvider_GetBalanceInfosRequest() {
        async { (completion) in
            let accountProvider = AccountProvider(server: RPCServer.shared)
            _ = accountProvider.getBalanceInfos(address: Address(string: "vite_7945df07bbf55f5afc76360a263b0870795ce5d1ecea36b786")).done { balanceInfos in
                print("🏆\(balanceInfos)")
                completion()
            }
        }
    }

//    func testTransactionProvider_GetUnconfirmedTransactionRequest_no() {
//        async { (completion) in
//            let transactionProvider = TransactionProvider(server: RPCServer.shared)
//            _ = transactionProvider.getUnconfirmedTransaction(address: Address(string: "vite_7945df07bbf55f5afc76360a263b0870795ce5d1ecea36b786"))
//                .then({ accountBlocks -> Promise<Void> in
//                    if let accountBlock = accountBlocks.first {
//                        return transactionProvider.createTransaction(accountBlock: accountBlock)
//                    } else {
//                        return Promise { $0.fulfill(Void()) }
//                    }
//                })
//                .done({
//                    print("🏆")
//                })
//                .catch({ (error) in
//                    print("🤯🤯🤯🤯🤯🤯\(error)")
//                })
//                .finally({
//                    completion()
//                })
//        }
//    }

//    func testTransactionProvider_GetUnconfirmedTransactionRequest() {
//        async { (completion) in
//            let transactionProvider = TransactionProvider(server: RPCServer.shared)
//            _ = transactionProvider.getUnconfirmedTransaction(address: Address(string: "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7"))
//                .then({ accountBlocks -> Promise<Void> in
//                    if let accountBlock = accountBlocks.first {
//                        return transactionProvider.createTransaction(accountBlock: accountBlock)
//                    } else {
//                        return Promise { $0.fulfill(Void()) }
//                    }
//                })
//                .done({
//                    print("🏆")
//                })
//                .catch({ (error) in
//                    print("🤯🤯🤯🤯🤯🤯\(error)")
//                })
//                .finally({
//                    completion()
//            })
//        }
//    }

//    func testSend() {
//        async { (completion) in
//            let transactionProvider = TransactionProvider(server: RPCServer.shared)
//            _ = transactionProvider.getLatestAccountBlock(address: Address(string: "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7"))
//                .then({ accountBlock -> Promise<Void> in
//                    let bag = HDWalletManager.instance.bag()
//                    let send = accountBlock.makeSendAccountBlock(latestAccountBlock: accountBlock, bag: bag, toAddress: "vite_7945df07bbf55f5afc76360a263b0870795ce5d1ecea36b786", tokenId: Token.Currency.vite.rawValue, amount: BigInt(1000000000000000000))
//                    return transactionProvider.createTransaction(accountBlock: send)
//                })
//                .done({
//                    print("🏆")
//                })
//                .catch({ (error) in
//                    print("🤯🤯🤯🤯🤯🤯\(error)")
//                })
//                .finally({
//                    completion()
//                })
//        }
//    }

    func testAddress() {
        let correct = "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7"
        let error = "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e6"
        XCTAssert(Address.isValid(string: correct))
        XCTAssert(!Address.isValid(string: error))
    }

    func testGetTokenInfo() {
        async { (completion) in
            let accountProvider = AccountProvider(server: RPCServer.shared)
            _ = accountProvider.getTokenForId("tti_000000000000000000004cfd").done { token in
                print("🏆\(token)")
                completion()
            }
        }
    }

//    func testAccountBlock() {
//        let string = "{\"prevHash\":\"810007e4c84fe1624bae5105130165a462fe66d22d1bd8c2431b463b75bde0b3\",\"tokenId\":\"tti_000000000000000000004cfd\",\"snapshotTimestamp\":\"606770e4dea298d492f99a2d40e4be5468baa0dba408f93f443bbf9a47db26f0\",\"nonce\":\"0000000000\",\"publicKey\":\"36105734843edfec74185bea38d0dbb30d0b213d07a75c3cc903c4c1ce333f5f\",\"hash\":\"ab528d72934b499805a7242ea15b503e24ef95af4e1eecb3a6a977fa24c85dbb\",\"difficulty\":\"0000000000\",\"amount\":\"1234567890123456789\",\"to\":\"vite_18068b64b49852e1c4dfbc304c4e606011e068836260bc9975\",\"accountAddress\":\"vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7\",\"meta\":{\"height\":\"3\"},\"fAmount\":\"0\",\"signature\":\"f215e9592d5234110a5e8d4d93dc4e0bc013092ff3bd89eb235fadc103bece1bacf7a1a2b8804928e78fa2b09ca84be3a6d85e4171b1db14f117645f7988c60a\"}"
//        let block = AccountBlock(JSONString: string)!
//
//        let (hash, signature) = AccountBlock.sign(accountBlock: block, secretKeyHexString: "ddbe2b5d3744db659fdb049e7b841bdbdf93ce304c62212ce59a3e4727e594f1", publicKeyHexString: "36105734843edfec74185bea38d0dbb30d0b213d07a75c3cc903c4c1ce333f5f")
//
//        XCTAssertEqual(block.hash, hash)
//        XCTAssertEqual(block.signature, signature)
//    }
}
