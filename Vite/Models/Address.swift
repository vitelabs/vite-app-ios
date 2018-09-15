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
        return (self as NSString).substring(with: NSMakeRange(5, 40)) as String
    }

    var tokenIdStrip: String {
        return (self as NSString).substring(with: NSMakeRange(4, 24)) as String
    }
}
