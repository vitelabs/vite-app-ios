//
//  WalletDataService.swift
//  Vite
//
//  Created by Water on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import Vite_keystore

public class WalletDataService {
    static let shareInstance = WalletDataService()

    var defaultWalletAccount: WalletAccount?
    var defaultWalletAccountIndex = 0

    var walletStorage = WalletStorage.shareInstance

    func isExistWallet() -> Bool {
        return walletStorage.walletAccounts.isEmpty
    }
}
