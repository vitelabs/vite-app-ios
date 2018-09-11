//
//   CreateWalletService.swift
//  Vite
//
//  Created by Water on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import Vite_keystore

class CreateWalletService {
    static let sharedInstance = CreateWalletService()

    public var walletAccount = WalletAccount()

    func clearData() {
        walletAccount = WalletAccount()
    }
}
