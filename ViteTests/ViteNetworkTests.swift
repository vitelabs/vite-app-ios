//
//  ViteNetworkTests.swift
//  ViteTests
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import XCTest
import PromiseKit
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
        waitForExpectations(timeout: 15, handler: nil)
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

    func testTransactionProvider_GetUnconfirmedTransactionRequest() {
        async { (completion) in
            let transactionProvider = TransactionProvider(server: RPCServer.shared)
            _ = transactionProvider.getUnconfirmedTransaction(address: Address(string: "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7")).done { accountBlock in
                print("🏆\(accountBlock)")
                }.catch({ (error) in
                    print("🤯🤯🤯🤯🤯🤯\(error)")
                }).finally {
                    completion()
            }
        }
    }
}
