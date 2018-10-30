//
//  AddressManageAddressViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class AddressManageAddressViewModel: AddressManageAddressViewModelType {

    let number: Int
    let address: String
    let isSelected: Bool

    init(number: Int, address: String, isSelected: Bool) {
        self.number = number
        self.address = address
        self.isSelected = isSelected
    }
}
