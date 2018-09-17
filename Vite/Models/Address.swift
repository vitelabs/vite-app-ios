//
//  Address.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

struct Address: CustomStringConvertible {

    static func isValid(string: String) -> Bool {
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
}

extension String {
    var addressStrip: String {
        guard count == 45 else { return "" }
        return (self as NSString).substring(with: NSRange(location: 5, length: 40)) as String
    }

    var tokenIdStrip: String {
        guard count == 28 else { return "" }
        return (self as NSString).substring(with: NSRange(location: 4, length: 24)) as String
    }
}
