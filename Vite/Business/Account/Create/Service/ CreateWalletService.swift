//
//   CreateWalletService.swift
//  Vite
//
//  Created by Water on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import Vite_HDWalletKit

class CreateWalletService {
    static let sharedInstance = CreateWalletService()

    var name: String = ""
    var mnemonic: String = ""
    var password: String = ""

    func clearData() {
        name = ""
        mnemonic = ""
        password = ""
    }
}
