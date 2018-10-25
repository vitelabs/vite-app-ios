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

    func getUnconfirmedTransaction(_ uuid: String) {
        guard uuid == self.uuid else { return }
        guard let bag = HDWalletManager.instance.bag else { return }
        plog(level: .debug, log: bag.address.description, tag: .transaction)
        Provider.instance.receiveTransactionWithGetPow(bag: bag) { [weak self] _ in
            guard let `self` = self else { return }
            guard uuid == self.uuid else { return }
            GCD.delay(2) { self.getUnconfirmedTransaction(uuid) }
        }
    }
}
