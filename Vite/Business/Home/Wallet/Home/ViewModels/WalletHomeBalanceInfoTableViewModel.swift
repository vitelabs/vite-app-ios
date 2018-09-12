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
    fileprivate let balanceInfos: BehaviorRelay<[WalletHomeBalanceInfoViewModelType]>
    fileprivate let address: Address

    fileprivate let disposeBag = DisposeBag()
    fileprivate let accountProvider = AccountProvider(server: RPCServer.shared)

    deinit {
        print("deinit WalletHomeBalanceInfoTableViewModel")
    }

    init(address: Address) {
        self.address = address
        // TODO: need cache
        balanceInfos = BehaviorRelay<[WalletHomeBalanceInfoViewModelType]>(value: [])

        getBalanceInfos()
        Observable<Int>.interval(5, scheduler: MainScheduler.instance).bind { [weak self] _ in
            self?.getBalanceInfos()
        }.disposed(by: disposeBag)
    }

    private func getBalanceInfos() {
        _ = accountProvider.getBalanceInfos(address: address).done { [weak self] balanceInfos in
            self?.balanceInfos.accept(BalanceInfo.mergeBalanceInfos(balanceInfos).map {
                WalletHomeBalanceInfoViewModel(balanceInfo: $0)
            })
        }
    }
}
