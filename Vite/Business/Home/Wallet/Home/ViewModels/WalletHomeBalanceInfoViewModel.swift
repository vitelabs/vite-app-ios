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
    let icon: Token.Icon
    let backgroundColors: [UIColor]
    let name: String
    let balance: String
    let unconfirmed: String
    let unconfirmedCount: Int

    init(balanceInfo: BalanceInfo) {
        self.tokenId = balanceInfo.token.id
        self.icon = TokenCacheService.instance.iconForId(balanceInfo.token.id)
        self.backgroundColors = TokenCacheService.instance.backgroundColorsForId(balanceInfo.token.id)
        self.name = balanceInfo.token.name
        self.balance = balanceInfo.balance.amountShort(decimals: balanceInfo.token.decimals)
        self.unconfirmed = balanceInfo.unconfirmedBalance.amountShort(decimals: balanceInfo.token.decimals)
        self.unconfirmedCount = balanceInfo.unconfirmedCount
    }
}
