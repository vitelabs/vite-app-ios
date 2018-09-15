//
//  AutoGatheringService.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import PromiseKit

final class AutoGatheringService {
    static let instance = AutoGatheringService()
    private init() {}

    let transactionProvider = TransactionProvider(server: RPCServer.shared)

    func start() {
        getUnconfirmedTransaction()
    }

    func getUnconfirmedTransaction() {

        print("\(AccountBlock.test)")

//        _ = transactionProvider.getUnconfirmedTransaction(address: Address(string: "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7"))
//            .done { accountBlocks in
//                if let accountBlock = accountBlocks.first {
//                    print("🏆")
//                    GCD.delay(1) { self.getUnconfirmedTransaction() }
//                } else {
//                    GCD.delay(1) { self.getUnconfirmedTransaction() }
//                }
//            }.catch({ (error) in
//                print("🤯🤯🤯🤯🤯🤯\(error)")
//                GCD.delay(1) { self.getUnconfirmedTransaction() }
//            })
        _ = transactionProvider.getUnconfirmedTransaction(address: Address(string: "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7"))
            .then({ (accountBlocks, latestAccountBlock) -> Promise<Void> in
                if let accountBlock = accountBlocks.first {
                    let key = WalletDataService.shareInstance.defaultWalletAccount!.defaultKey
                    let receiveAccountBlock = accountBlock.makeReceiveAccountBlock(latestAccountBlock: latestAccountBlock, key: key)
                    return self.transactionProvider.createTransaction(accountBlock: receiveAccountBlock)
                } else {
                    return Promise { $0.fulfill(Void()) }
                }
            })
            .done({
                print("🏆")
            })
            .catch({ (error) in
                print("🤯🤯🤯🤯🤯🤯\(error)")
            })
            .finally({
                print("fsfs")
            })
    }
}
