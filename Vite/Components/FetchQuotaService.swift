//
//  FetchQuotaService.swift
//  Vite
//
//  Created by Stone on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import RxCocoa
import RxOptional

final class FetchQuotaService {

    static let instance = FetchQuotaService()
    private init() {}

    lazy var  quotaDriver: Driver<String> = self.quotaBehaviorRelay.asDriver()
    lazy var  maxTxCountDriver: Driver<String> = self.maxTxCountBehaviorRelay.asDriver()
    fileprivate var quotaBehaviorRelay: BehaviorRelay<String> = BehaviorRelay(value: "0")
    fileprivate var maxTxCountBehaviorRelay: BehaviorRelay<String> = BehaviorRelay(value: "0")

    fileprivate let disposeBag = DisposeBag()
    fileprivate var uuid: String! = nil
    fileprivate var fileHelper: FileHelper! = nil
    fileprivate var retainCount = 0

    fileprivate enum Key: String {
        case fileName = "PledgeQuota"
        case quota
        case maxTxCount
    }

    func start() {
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] in
            guard let `self` = self else { return }

            self.fileHelper = FileHelper(.library, appending: "\(FileHelper.accountPathComponent)/\($0.address.description)")
            if let data = self.fileHelper.contentsAtRelativePath(Key.fileName.rawValue),
                let dic = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                let quota = dic?[Key.quota.rawValue],
                let maxTxCount = dic?[Key.maxTxCount.rawValue] {
                self.quotaBehaviorRelay.accept(quota)
                self.maxTxCountBehaviorRelay.accept(maxTxCount)
            }

            if self.retainCount > 0 {
                self.uuid = UUID().uuidString
                self.getQuota(self.uuid)
            }
        }).disposed(by: disposeBag)
    }

    func retainQuota() {
        retainCount += 1
        startFetchIfNeeded()
    }

    func releaseQuota() {
        retainCount = max(0, retainCount - 1)
    }

    fileprivate func startFetchIfNeeded() {
        if retainCount == 1 {
            self.uuid = UUID().uuidString
            self.getQuota(self.uuid)
        }
    }

    fileprivate func getQuota(_ uuid: String) {
        guard uuid == self.uuid else { return }
        guard let bag = HDWalletManager.instance.bag else { return }
        plog(level: .debug, log: bag.address.description, tag: .transaction)
        Provider.instance.getPledgeQuota(address: bag.address) { [weak self] result in
            guard let `self` = self else { return }
            guard uuid == self.uuid else { return }

            switch result {
            case .success(let quota, let maxTxCount):
                self.quotaBehaviorRelay.accept(quota)
                self.maxTxCountBehaviorRelay.accept(maxTxCount)

                let dic = [Key.quota.rawValue: quota, Key.maxTxCount.rawValue: maxTxCount]
                if let data = try? JSONSerialization.data(withJSONObject: dic) {
                    do {
                        try self.fileHelper.writeData(data, relativePath: Key.fileName.rawValue)
                    } catch let error {
                        assert(false, error.localizedDescription)
                    }
                }

            case .error(let error):
                plog(level: .warning, log: bag.address.description + ": " + error.message, tag: .transaction)
            }

            if self.retainCount > 0 {
                GCD.delay(5, task: { self.getQuota(uuid) })
            }
        }
    }
}
