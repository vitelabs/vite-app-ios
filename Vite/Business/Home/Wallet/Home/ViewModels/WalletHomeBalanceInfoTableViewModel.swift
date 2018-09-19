//
//  WalletHomeBalanceInfoTableViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WalletHomeBalanceInfoTableViewModel: WalletHomeBalanceInfoTableViewModelType {
    lazy var  balanceInfosDriver = FetchBalanceInfoService.instance.balanceInfosDriver
}
