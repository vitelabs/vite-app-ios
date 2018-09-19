//
//  FetchBalanceInfoService.swift
//  Vite
//
//  Created by Stone on 2018/9/19.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import RxCocoa

final class FetchBalanceInfoService {

    static let instance = FetchBalanceInfoService()
    private init() {}

    lazy var  balanceInfosDriver: Driver<[WalletHomeBalanceInfoViewModelType]> = self.balanceInfos.asDriver()
    fileprivate var balanceInfos: BehaviorRelay<[WalletHomeBalanceInfoViewModelType]>! = nil

    fileprivate let disposeBag = DisposeBag()
    fileprivate let accountProvider = AccountProvider(server: RPCServer.shared)

    fileprivate var address: Address! = nil
    fileprivate var fileHelper: FileHelper! = nil
    fileprivate static let saveKey = "BalanceInfos"

    func start() {
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.address = $0.address

            self.fileHelper = FileHelper(.library, appending: "\(FileHelper.accountPathComponent)/\(self.address.description)")

            var oldBalanceInfos: [BalanceInfo]!
            if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
                let jsonString = String(data: data, encoding: .utf8),
                let array = [BalanceInfo](JSONString: jsonString) {
                oldBalanceInfos = array
            } else {
                oldBalanceInfos = BalanceInfo.mergeBalanceInfos([])
            }

            self.balanceInfos = BehaviorRelay<[WalletHomeBalanceInfoViewModelType]>(value: oldBalanceInfos.map {
                WalletHomeBalanceInfoViewModel(balanceInfo: $0)
            })
            self.getchBalanceInfo()
        }).disposed(by: disposeBag)

    }

    func getchBalanceInfo() {
        guard HDWalletManager.instance.hasAccount else { return }

        _ = accountProvider.getBalanceInfos(address: self.address)
            .done({ [weak self] balanceInfos in
                let allBalanceInfos = BalanceInfo.mergeBalanceInfos(balanceInfos)

                let tokens = allBalanceInfos.map { $0.token }
                TokenCacheService.instance.updateTokensIfNeeded(tokens)

                if let data = allBalanceInfos.toJSONString()?.data(using: .utf8) {
                    do {
                        try self?.fileHelper.writeData(data, relativePath: FetchBalanceInfoService.saveKey)
                    } catch let error {
                        assert(false, error.localizedDescription)
                    }

                }
                self?.balanceInfos.accept(allBalanceInfos.map { WalletHomeBalanceInfoViewModel(balanceInfo: $0) })
                print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): \(self!.address.description)")
            })
            .catch({ (error) in
                print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): 🤯\(error)")
            })
            .finally({ [weak self] in
                if let `self` = self {
                    GCD.delay(5) { self.getchBalanceInfo() }
                }
            })
    }
}
