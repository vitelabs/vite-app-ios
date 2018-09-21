//
//  WalletDataService.swift
//  Vite
//
//  Created by Water on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import Vite_keystore
import CryptoSwift

public class WalletDataService: NSObject {
    static let shareInstance = WalletDataService()

    private let walletStorage: WalletStorage
    //current login account
    public var defaultWalletAccount: WalletAccount?

    public func verifyWalletPassword(pwd: String) -> Bool {
        let  md5 = pwd.pwdEncrypt()
        return self.defaultWalletAccount?.password == md5
    }

    public override init() {
        walletStorage = WalletStorage()
        defaultWalletAccount = walletStorage.walletAccounts.first
        // 为了保存新增的uuid，读取之后就先保存一下
        walletStorage.storeAllWallets()
    }

    public func isExistWallet() -> Bool {
        return walletStorage.walletAccounts.isEmpty
    }

    public func addWallet(account: WalletAccount) {
        walletStorage.add(account: account)
    }

    public func updateWallet(account: WalletAccount) {
        if walletStorage.isExist(account) {
              walletStorage.update(account: account)
        }else{
              walletStorage.add(account: account)
        }
    }

    public func loginWallet(account: WalletAccount) {
        account.isLogin = true
        walletStorage.login(replace: account)
        self.defaultWalletAccount = walletStorage.walletAccounts.first!
        walletStorage.storeAllWallets()
    }

    //if  exist wallet , true has wallets, false no wallets
    public func logoutCurrentWallet() {
        self.defaultWalletAccount?.isLogin = false
        walletStorage.storeAllWallets()
    }

   //true has wallets and , false no wallets
    public func existWalletAndLogout() -> Bool {
        if !walletStorage.walletAccounts.isEmpty && !(walletStorage.walletAccounts.first?.isLogin)! {
            return true
        } else {
            return false
        }
    }

    public func delAllWalletData() {
        walletStorage.delAllWallet()
    }
}
