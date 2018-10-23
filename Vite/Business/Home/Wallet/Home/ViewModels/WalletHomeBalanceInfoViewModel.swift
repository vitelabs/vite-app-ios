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

    let token: Token
    let symbol: String
    let balance: Balance
    let unconfirmed: Balance
    let unconfirmedCount: UInt64

    init(balanceInfo: BalanceInfo) {
        self.token = balanceInfo.token
        self.symbol = balanceInfo.token.symbol
        self.balance = balanceInfo.balance
        self.unconfirmed = balanceInfo.unconfirmedBalance
        self.unconfirmedCount = balanceInfo.unconfirmedCount
    }
}
