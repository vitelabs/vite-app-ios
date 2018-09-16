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

        let key = WalletDataService.shareInstance.defaultWalletAccount!.defaultKey
        _ = transactionProvider.getUnconfirmedTransaction(address: Address(string: key.address))
            .then({ (accountBlocks, latestAccountBlock, snapshotChainHash) -> Promise<Void> in
                if let accountBlock = accountBlocks.first {
                    let key = WalletDataService.shareInstance.defaultWalletAccount!.defaultKey
                    let receiveAccountBlock = accountBlock.makeReceiveAccountBlock(latestAccountBlock: latestAccountBlock, key: key, snapshotChainHash: snapshotChainHash)
                    return self.transactionProvider.createTransaction(accountBlock: receiveAccountBlock)
                } else {
                    return Promise { $0.fulfill(Void()) }
                }
            })
            .done({
                print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): 🏆")
            })
            .catch({ (error) in
                print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): 🤯\(error)")
            })
            .finally({
                GCD.delay(2) { self.getUnconfirmedTransaction() }
            })
    }

}
