//
//  AutoGatheringService.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import RxCocoa

final class AutoGatheringService {
    static let instance = AutoGatheringService()
    private init() {}

    let disposeBag = DisposeBag()
    let transactionProvider = TransactionProvider(server: RPCServer.shared)
    var bag: HDWalletManager.Bag! = nil

    func start() {
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] in self?.bag = $0 }).disposed(by: disposeBag)
        getUnconfirmedTransaction()
    }

    func getUnconfirmedTransaction() {

        _ = transactionProvider.getUnconfirmedTransaction(address: self.bag.address)
            .then({ [weak self] (accountBlocks, latestAccountBlock, snapshotChainHash) -> Promise<Void> in
                guard let `self` = self else { return Promise { $0.fulfill(Void()) } }
                if let accountBlock = accountBlocks.first {
                    let receiveAccountBlock = accountBlock.makeReceiveAccountBlock(latestAccountBlock: latestAccountBlock, bag: self.bag, snapshotChainHash: snapshotChainHash)
                    return self.transactionProvider.createTransaction(accountBlock: receiveAccountBlock)
                } else {
                    return Promise { $0.fulfill(Void()) }
                }
            })
            .done({ [weak self] in
                print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): \(self!.bag.address.description)")
            })
            .catch({ (error) in
                print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): 🤯\(error)")
            })
            .finally({ [weak self] in
                if let `self` = self {
                    GCD.delay(2) { self.getUnconfirmedTransaction() }
                }
            })
    }
}
