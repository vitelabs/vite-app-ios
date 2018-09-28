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
    fileprivate var bag: HDWalletManager.Bag! = nil

    fileprivate var uuid: String! = nil

    func start() {
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.bag = $0
            self.uuid = UUID().uuidString
            self.getUnconfirmedTransaction(self.uuid)
        }).disposed(by: disposeBag)
    }

    func getUnconfirmedTransaction(_ uuid: String) {
        guard uuid == self.uuid else { return }
        guard HDWalletManager.instance.hasAccount else { return }

        Provider.instance.receiveTransaction(bag: self.bag) { [weak self] in
            guard let `self` = self else { return }
            guard uuid == self.uuid else { return }

            print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): \($0)")
            GCD.delay(2) { self.getUnconfirmedTransaction(uuid) }
        }
    }
}
