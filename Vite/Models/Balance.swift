//
//  Balance.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import BigInt

struct Balance: BalanceType, CustomStringConvertible {

    var value: BigInt

    init(value: BigInt = BigInt(0)) {
        self.value = value
    }

    func amountShort(decimals: Int) -> String {
        let denominator = BigInt(10).power(decimals)
        let integer = (value/denominator).description
        var decimal = (value%denominator).description
        if decimal.count > 4 {
            decimal = (decimal as NSString).substring(to: 4) as String
        }
        return "\(integer).\(decimal)"
    }

    func amountFull(decimals: Int) -> String {
        let denominator = BigInt(10).power(decimals)
        let integer = (value/denominator).description
        var decimal = (value%denominator).description
        if decimal.count > 4 {
            decimal = (decimal as NSString).substring(to: 8) as String
        }
        return "\(integer).\(decimal)"
    }

    var raw: String {
        return value.description
    }

    var description: String {
        return (value/1000000000000000000).description
    }
}
