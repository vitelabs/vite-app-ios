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
