//
//  WalletHomeBalanceInfoViewModelType.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import UIKit

protocol WalletHomeBalanceInfoViewModelType {

    var token: Token { get }
    var symbol: String { get }
    var balance: Balance { get }
    var unconfirmed: Balance { get }
    var unconfirmedCount: UInt64 { get }
}
