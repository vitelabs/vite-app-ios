//
//  JSONTransformer.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

struct JSONTransformer {
    static let timestamp = TransformOf<Date, UInt64>(fromJSON: { (timestamp) -> Date? in
        guard let timestamp = timestamp else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }, toJSON: { (date) -> UInt64? in
        guard let date = date else { return nil }
        return UInt64(date.timeIntervalSinceNow)
    })

    static let address = TransformOf<Address, String>(fromJSON: { (string) -> Address? in
        guard let string = string else { return nil }
        return Address(string: string)
    }, toJSON: { (address) -> String? in
        guard let address = address else { return nil }
        return address.description
    })

    static let bigint = TransformOf<BigInt, String>(fromJSON: { (string) -> BigInt? in
        guard let string = string, let bigInt = BigInt(string) else { return nil }
        return bigInt
    }, toJSON: { (bigint) -> String? in
        guard let bigint = bigint else { return nil }
        return String(bigint)
    })

    static let balance = TransformOf<Balance, String>(fromJSON: { (string) -> Balance? in
        guard let string = string, let bigInt = BigInt(string) else { return nil }
        return Balance(value: bigInt)
    }, toJSON: { (balance) -> String? in
        guard let balance = balance else { return nil }
        return String(balance.value)
    })
}
