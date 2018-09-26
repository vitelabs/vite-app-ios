//
//  Balance.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import BigInt

struct Balance: BalanceType {

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
}

extension String {

    func toBigInt(decimals: Int) -> BigInt? {

        var decimalDigits = 0
        do {
            let array = components(separatedBy: ".")
            if array.count == 1 {
                decimalDigits = 0
            } else if array.count == 2 {
                decimalDigits = Int(array.last!.count)
            } else {
                return nil
            }
        }

        guard decimalDigits <= decimals else { return nil }
        guard let base = BigInt(replacingOccurrences(of: ".", with: "")) else { return nil }
        return base * BigInt(10).power(decimals - decimalDigits)
    }
}
