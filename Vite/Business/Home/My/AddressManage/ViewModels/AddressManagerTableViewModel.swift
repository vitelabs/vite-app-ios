//
//  AddressManagerTableViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Vite_keystore

class AddressManagerTableViewModel: AddressManagerTableViewModelType {

    lazy var defaultAddressDriver: Driver<String> = self.defaultAddress.asDriver()
    lazy var addressesDriver: Driver<[AddressManageAddressViewModelType]> = self.addresses.asDriver()
    var canGenerateAddress: Bool { return self.account.canGenerateAddress }

    fileprivate let defaultAddress: BehaviorRelay<String>
    fileprivate let addresses: BehaviorRelay<[AddressManageAddressViewModelType]>

    fileprivate let account: WalletAccount

    deinit {
        print("deinit AddressManagerTableViewModel")
    }

    init(account: WalletAccount) {
        self.account = account
        defaultAddress = BehaviorRelay<String>(value: account.defaultKey.address)
        var number = 0
        addresses = BehaviorRelay<[AddressManageAddressViewModelType]>(value: account.existKeys.map({
            number += 1
            let isSelected = account.defaultKey.address == $0.address
            return AddressManageAddressViewModel(number: number, address: $0.address, isSelected: isSelected)
        }))
    }

    func generateAddress() {
        account.generateAddress()
        updare()
    }

    func setDefaultAddressIndex(_ index: Int) {
        account.setDefaultAddressIndex(index)
        updare()
    }

    private func updare() {
        defaultAddress.accept(account.defaultKey.address)
        var number = 0
        addresses.accept(account.existKeys.map({
            number += 1
            let isSelected = account.defaultKey.address == $0.address
            return AddressManageAddressViewModel(number: number, address: $0.address, isSelected: isSelected)
        }))
    }

}
