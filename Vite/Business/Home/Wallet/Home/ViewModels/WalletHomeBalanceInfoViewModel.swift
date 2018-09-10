//
//  WalletHomeBalanceInfoViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WalletHomeBalanceInfoViewModel: WalletHomeBalanceInfoViewModelType {

    let tokenId: String
    let iconImage: UIImage
    let name: String
    let balance: String
    let unconfirmed: String
    let unconfirmedCount: Int

    init(tokenId: String, iconImage: UIImage, name: String, balance: String, unconfirmed: String, unconfirmedCount: Int) {
        self.tokenId = tokenId
        self.iconImage = iconImage
        self.name = name
        self.balance = balance
        self.unconfirmed = unconfirmed
        self.unconfirmedCount = unconfirmedCount
    }
}
