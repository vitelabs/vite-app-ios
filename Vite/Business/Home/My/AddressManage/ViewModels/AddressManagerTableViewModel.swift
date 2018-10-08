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
import Vite_HDWalletKit

class AddressManagerTableViewModel: AddressManagerTableViewModelType {

    lazy var defaultAddressDriver: Driver<String> = HDWalletManager.instance.bagDriver.map { $0.address.description }
    lazy var addressesDriver: Driver<[AddressManageAddressViewModelType]> =
        Driver.combineLatest(HDWalletManager.instance.bagsDriver, HDWalletManager.instance.bagDriver)
            .map { (bags, _) -> [AddressManageAddressViewModelType] in
                var number = 0
                return bags.map { bag -> AddressManageAddressViewModelType in
                    let isSelected = number == HDWalletManager.instance.selectBagIndex()
                    number += 1
                    return AddressManageAddressViewModel(number: number, address: bag.address.description, isSelected: isSelected)
                }
            }

    var canGenerateAddress: Bool { return HDWalletManager.instance.canGenerateNextBag() }

    func generateAddress() {
        _ = HDWalletManager.instance.generateNextBag()
    }

    func setDefaultAddressIndex(_ index: Int) {
        _ = HDWalletManager.instance.selectBag(index: index)
    }
}
