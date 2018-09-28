//
//  Address.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import Vite_keystore

struct Address: CustomStringConvertible {

    static func isValid(string: String) -> Bool {
        guard string.count == 55 else { return false }
        let prefix = (string as NSString).substring(to: 5) as String
        let hash = (string as NSString).substring(with: NSRange(location: 5, length: 40)) as String
        let checksum = (string as NSString).substring(from: 45) as String
        guard prefix == "vite_" else { return false }
        guard checksum == Blake2b.hash(outLength: 5, in: hash.hex2Bytes)?.toHexString() else { return false }
        return true
    }

    private var address: String
    let isValid: Bool

    init(string: String = "") {
        isValid = Address.isValid(string: string)
        address = string
    }

    var description: String {
        return address
    }

    var raw: String {
        guard address.count == 55 else { return "" }
        let string = (address as NSString).substring(with: NSRange(location: 5, length: 40)) as String
        return string
    }
}
