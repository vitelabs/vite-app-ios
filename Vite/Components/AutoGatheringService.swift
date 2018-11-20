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

    fileprivate let disposeBag = DisposeBag()
    fileprivate var uuid: String! = nil

    func start() {
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.uuid = UUID().uuidString
            self.getUnconfirmedTransaction(self.uuid)
        }).disposed(by: disposeBag)
    }

    fileprivate func getUnconfirmedTransaction(_ uuid: String) {
        guard uuid == self.uuid else { return }
        guard let bag = HDWalletManager.instance.bag else { return }
        plog(level: .debug, log: bag.address.description, tag: .transaction)

        Provider.instance.receiveTransactionWithoutGetPow(bag: bag) { [weak self] (result) in
            guard let `self` = self else { return }
            guard uuid == self.uuid else { return }

            switch result {
            case .success:
                GCD.delay(2) { self.getUnconfirmedTransaction(uuid) }
            case .failure(let error):
                if error.code == ViteErrorCode.rpcNotEnoughQuota {

                    Provider.instance.receiveTransactionWithGetPow(bag: bag, difficulty: AccountBlock.Const.Difficulty.receive.value) { [weak self] result in
                        guard let `self` = self else { return }
                        guard uuid == self.uuid else { return }

                        switch result {
                        case .success:
                            break
                        case .failure(let error):
                            plog(level: .warning, log: bag.address.description + ": " + error.message, tag: .transaction)
                        }
                        GCD.delay(2) { self.getUnconfirmedTransaction(uuid) }
                    }
                } else {
                    plog(level: .warning, log: bag.address.description + ": " + error.message, tag: .transaction)
                    GCD.delay(2) { self.getUnconfirmedTransaction(uuid) }
                }
            }
        }
    }
}
