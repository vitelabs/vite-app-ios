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

    //current login account
    public var defaultWalletAccount: WalletAccount = WalletStorage.shareInstance.walletAccounts.first!

    public func isExistWallet() -> Bool {
        return WalletStorage.shareInstance.walletAccounts.isEmpty
    }

    public func loginWallet(account: WalletAccount) {
        account.isLogin = true
        WalletStorage.shareInstance.login(replace: account)
        self.defaultWalletAccount = WalletStorage.shareInstance.walletAccounts.first!
        WalletStorage.shareInstance.storeAllWallets()
    }

    //if  exist wallet , true has wallets, false no wallets
    public func logoutCurrentWallet() {
        self.defaultWalletAccount.isLogin = false
        WalletStorage.shareInstance.storeAllWallets()
    }

   //true has wallets and , false no wallets
    public func existWalletAndLogout() -> Bool {
        if !WalletStorage.shareInstance.walletAccounts.isEmpty && !(WalletStorage.shareInstance.walletAccounts.first?.isLogin)! {
            return true
        } else {
            return false
        }
    }
}
