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

final class WalletHomeAddressViewModel: WalletHomeAddressViewModelType {

    lazy var nameDriver: Driver<String> = self.name.asDriver()
    lazy var defaultAddressDriver: Driver<String> = self.defaultAddress.asDriver().map({ $0.description })

    fileprivate let account: Account
    fileprivate let name: Variable<String>
    fileprivate let defaultAddress: Variable<Address>

    init(account: Account) {
        self.account = account
        name = Variable(account.name)
        defaultAddress = Variable(account.defaultAddress)
    }

    func copy() {
        UIPasteboard.general.string = account.defaultAddress.description
        print("copy: \(account.defaultAddress.description)")
    }
}
