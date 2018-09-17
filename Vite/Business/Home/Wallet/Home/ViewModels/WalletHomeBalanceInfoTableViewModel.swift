//
//  WalletHomeBalanceInfoTableViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WalletHomeBalanceInfoTableViewModel: WalletHomeBalanceInfoTableViewModelType {

    lazy var  balanceInfosDriver: Driver<[WalletHomeBalanceInfoViewModelType]> = self.balanceInfos.asDriver()
    fileprivate var balanceInfos: BehaviorRelay<[WalletHomeBalanceInfoViewModelType]>! = nil

    fileprivate let disposeBag = DisposeBag()
    fileprivate let accountProvider = AccountProvider(server: RPCServer.shared)

    fileprivate var fileHelper: FileHelper! = nil
    fileprivate static let saveKey = "BalanceInfos"

    fileprivate var address: Address! = nil

    deinit {
        print("deinit WalletHomeBalanceInfoTableViewModel")
    }

    init() {

        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] in self?.address = $0.address }).disposed(by: disposeBag)

        self.fileHelper = FileHelper(.library, appending: "\(FileHelper.accountPathComponent)/\(address.description)")

        var oldBalanceInfos: [BalanceInfo]!
        if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let array = [BalanceInfo](JSONString: jsonString) {
            oldBalanceInfos = array
        } else {
            oldBalanceInfos = BalanceInfo.mergeBalanceInfos([])
        }

        balanceInfos = BehaviorRelay<[WalletHomeBalanceInfoViewModelType]>(value: oldBalanceInfos.map {
            WalletHomeBalanceInfoViewModel(balanceInfo: $0)
        })

        getBalanceInfos()
        Observable<Int>.interval(5, scheduler: MainScheduler.instance).bind { [weak self] _ in
            self?.getBalanceInfos()
        }.disposed(by: disposeBag)
    }

    private func getBalanceInfos() {
        print("\((#file as NSString).lastPathComponent)[\(#line)], \(#function): \(address.description)")
        _ = accountProvider.getBalanceInfos(address: address).done { [weak self] balanceInfos in
            let allBalanceInfos = BalanceInfo.mergeBalanceInfos(balanceInfos)

            let tokens = allBalanceInfos.map { $0.token }
            TokenCacheService.instance.updateTokensIfNeeded(tokens)

            if let data = allBalanceInfos.toJSONString()?.data(using: .utf8) {
                do {
                    try self?.fileHelper.writeData(data, relativePath: WalletHomeBalanceInfoTableViewModel.saveKey)
                } catch let error {
                    assert(false, error.localizedDescription)
                }

            }
            self?.balanceInfos.accept(allBalanceInfos.map { WalletHomeBalanceInfoViewModel(balanceInfo: $0) })
        }
    }
}
