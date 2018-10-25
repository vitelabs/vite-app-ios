//
//  QuotaManageViewController.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import BigInt

class QuotaManageViewController: BaseViewController {

    // FIXME: Optional
    let bag = HDWalletManager.instance.bag!

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(style: .blue, title: "抵押")
        view.addSubview(button)
        button.snp.makeConstraints { (m) in
            m.center.equalTo(view)
        }

        button.rx.tap.bind { [weak self] in
            guard let `self` = self else { return }
            self.pledgeAndGainQuotaWithoutGetPow(beneficialAddress: self.bag.address, amount: BigInt("10000000000000000000"))
        }.disposed(by: rx.disposeBag)
    }

    func pledgeAndGainQuotaWithoutGetPow(beneficialAddress: Address, amount: BigInt) {
        self.view.displayLoading(text: "")
        Provider.instance.pledgeAndGainQuotaWithoutGetPow(bag: bag, beneficialAddress: beneficialAddress, tokenId: TokenCacheService.instance.viteToken.id, amount: amount) { [weak self] (result) in
            guard let `self` = self else { return }
            self.view.hideLoading()
            switch result {
            case .success:
                Toast.show("success")
                GCD.delay(0.5) { self.dismiss() }
            case .error(let error):
                if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
                    Alert.show(into: self,
                               title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle.key.localized(),
                               message: nil,
                               actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton.key.localized()), nil)])
                } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
                    Alert.show(into: self, title: "没配额", message: nil, actions: [
                        (.default(title: "获取pow"), { _ in
                            self.pledgeAndGainQuotaWithGetPow(beneficialAddress: beneficialAddress, amount: amount)
                        }),
                        (.cancel, nil),
                        ])
                } else {
                    Toast.show(error.message)
                }
            }
        }
    }

    func pledgeAndGainQuotaWithGetPow(beneficialAddress: Address, amount: BigInt) {
        self.view.displayLoading(text: "获取pow")
        Provider.instance.pledgeAndGainQuotaWithGetPow(bag: bag, beneficialAddress: beneficialAddress, tokenId: TokenCacheService.instance.viteToken.id, amount: amount) { [weak self] (result) in
            guard let `self` = self else { return }
            self.view.hideLoading()
            switch result {
            case .success:
                Toast.show("success")
                GCD.delay(0.5) { self.dismiss() }
            case .error(let error):
                if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
                    Alert.show(into: self,
                               title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle.key.localized(),
                               message: nil,
                               actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton.key.localized()), nil)])
                } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
                    Toast.show("获取pow转账也失败了")
                } else {
                    Toast.show(error.message)
                }
            }
        }
    }
}
