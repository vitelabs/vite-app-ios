//
//  BalanceType.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import BigInt

protocol BalanceType {
    var value: BigInt { get }
    func amountShort(decimals: Int) -> String
    func amountFull(decimals: Int) -> String
}
