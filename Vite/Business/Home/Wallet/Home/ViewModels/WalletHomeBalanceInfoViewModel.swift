//
//  WalletHomeBalanceInfoViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

final class WalletHomeBalanceInfoViewModel: WalletHomeBalanceInfoViewModelType {

    let iconImage: UIImage
    let name: String
    let balance: String
    let unconfirmed: String

    init(iconImage: UIImage, name: String, balance: String, unconfirmed: String) {
        self.iconImage = iconImage
        self.name = name
        self.balance = balance
        self.unconfirmed = unconfirmed
    }
}
