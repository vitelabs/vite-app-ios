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
        return pri_amount(decimals: decimals, count: 4)
    }

    func amountFull(decimals: Int) -> String {
        return pri_amount(decimals: decimals, count: 8)
    }

    fileprivate func pri_amount(decimals: Int, count: Int) -> String {
        let denominator = BigInt(10).power(decimals)
        let integer = (value/denominator).description
        var decimal = (value%denominator).description

        if decimal.count < decimals {
            for _ in decimal.count..<decimals {
                decimal = "0" + decimal
            }
        }
        if decimal.count > count {
            decimal = (decimal as NSString).substring(to: count) as String
        }
        while decimal.count > 1 && decimal.hasSuffix("0") {
            decimal = String(decimal.dropLast())
        }
        return "\(integer).\(decimal)"
    }
}

extension String {

    func toBigInt(decimals: Int) -> BigInt? {

        var str = self

        if str.contains(".") {
            while str.last == "0" {
                str = String(str.dropLast())
            }

            if str.last == "." {
                str = String(str.dropLast())
            }
        }

        while str.first == "0" {
            if str.hasPrefix("0.") {
                break
            } else {
                str = String(str.dropFirst())
            }
        }

        if str.isEmpty {
            str = "0"
        }

        var decimalDigits = 0
        do {
            let array = str.components(separatedBy: ".")
            if array.count == 1 {
                decimalDigits = 0
            } else if array.count == 2 {
                decimalDigits = Int(array.last!.count)
            } else {
                return nil
            }
        }

        guard decimalDigits <= decimals else { return nil }
        guard let base = BigInt(str.replacingOccurrences(of: ".", with: "")) else { return nil }
        let ret = base * BigInt(10).power(decimals - decimalDigits)
        return ret
    }
}
