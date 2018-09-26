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
    var bag: HDWalletManager.Bag! = nil

    func start() {
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] in
            self?.bag = $0
            self?.getUnconfirmedTransaction()
        }).disposed(by: disposeBag)
    }

    func getUnconfirmedTransaction() {

        guard HDWalletManager.instance.hasAccount else { return }

        Provider.instance.receiveTransaction(bag: self.bag) { [weak self] in
             GCD.delay(2) { self?.getUnconfirmedTransaction() }
            print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): \($0)")
        }
    }
}
