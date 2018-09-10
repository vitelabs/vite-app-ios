//
//  Account.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

struct Account {

    fileprivate(set) var mnemonic: String
    fileprivate(set) var name: String
    fileprivate(set) var defaultAddressIndex: Int
    fileprivate(set) var existentAddressIndexs: [Int]

    var defaultAddress: Address {
        return Address(string: "vite_7945df07bbf55f5afc76360a263b0870795ce5d1ecea36b786")
    }

    var existentAddresses: [Address] {
        return [Address(string: "vite_7945df07bbf55f5afc76360a263b0870795ce5d1ecea36b786")]
    }

    init(mnemonic: String, name: String) {
        self.mnemonic = mnemonic
        self.name = name
        self.defaultAddressIndex = 0
        self.existentAddressIndexs = [0]
    }

    mutating func modifyName(_ name: String) {
        self.name = name
    }

    mutating func generateAddress() {
    }
}
