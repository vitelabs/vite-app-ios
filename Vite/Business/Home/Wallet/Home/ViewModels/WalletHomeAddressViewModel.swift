//
//  WalletHomeAddressViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class WalletHomeAddressViewModel: WalletHomeAddressViewModelType {

    let defaultAddressDriver: Driver<String> = HDWalletManager.instance.bagDriver.map({ $0.address.description })

    private var address: String?
    private let disposeBag = DisposeBag()

    init() {
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] bag in
            self?.address = bag.address.description
        }).disposed(by: disposeBag)
    }

    func copy() {
        UIPasteboard.general.string = address
        Toast.show(R.string.localizable.walletHomeToastCopyAddress.key.localized(), duration: 1.0)
    }
}
