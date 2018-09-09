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

    init?(string: String = "") {
        guard Address.isValid(string: string) else { return nil }
        address = string
    }

    var description: String {
        return address
    }
}
