//
//  AutoGatheringService.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

final class AutoGatheringService {
    static let instance = AutoGatheringService()
    private init() {}

    let transactionProvider = TransactionProvider(server: RPCServer.shared)

    func start() {
        getUnconfirmedTransaction()
    }

    func getUnconfirmedTransaction() {

        _ = transactionProvider.getUnconfirmedTransaction(address: Address(string: "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7"))
            .done { accountBlocks in
                if let accountBlock = accountBlocks.first {
                    print("🏆")
                    GCD.delay(1) { self.getUnconfirmedTransaction() }
                } else {
                    GCD.delay(1) { self.getUnconfirmedTransaction() }
                }
            }.catch({ (error) in
                print("🤯🤯🤯🤯🤯🤯\(error)")
                GCD.delay(1) { self.getUnconfirmedTransaction() }
            })
    }
}
