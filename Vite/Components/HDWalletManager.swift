//
//  HDWalletManager.swift
//  Vite
//
//  Created by Stone on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Vite_keystore
import ObjectMapper
import RxSwift
import RxCocoa

final class HDWalletManager {
    static let instance = HDWalletManager()
    private init() {}

    lazy var accountDriver: Driver<Account> = self.accountBehaviorRelay.asDriver()
    lazy var walletDriver: Driver<Wallet> = self.walletBehaviorRelay.asDriver()
    lazy var bagsDriver: Driver<[Bag]> = self.bagsBehaviorRelay.asDriver()
    lazy var bagDriver: Driver<Bag> = self.bagBehaviorRelay.asDriver()

    fileprivate var accountBehaviorRelay = BehaviorRelay(value: Account(uuid: "nil", mnemonic: "nil", passwordHash: "nil", name: "nil"))
    fileprivate var walletBehaviorRelay = BehaviorRelay(value: Wallet())
    fileprivate var bagsBehaviorRelay = BehaviorRelay(value: [Bag]())
    fileprivate var bagBehaviorRelay = BehaviorRelay(value: Bag())

    fileprivate(set) var hasAccount = false

    fileprivate var fileHelper: FileHelper!
    fileprivate static let saveKey = "HDWallet"

    func updateAccount(_ walletAccount: WalletAccount) {
        hasAccount = true
        accountBehaviorRelay.accept(Account(uuid: walletAccount.uuid,
                                            mnemonic: walletAccount.mnemonic,
                                            passwordHash: walletAccount.password,
                                            name: walletAccount.name))

        fileHelper = FileHelper(.library, appending: FileHelper.accountPathComponent)

        if let data = fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let w = Wallet(JSONString: jsonString) {
            walletBehaviorRelay.accept(w)
        } else {
            walletBehaviorRelay.accept(Wallet())
        }

        pri_updateBags()
        pri_updateBag()
    }

    func cleanAccount() {
        hasAccount = false
        accountBehaviorRelay.accept(Account(uuid: "nil", mnemonic: "nil", passwordHash: "nil", name: "nil"))
        fileHelper = nil
        walletBehaviorRelay.accept(Wallet())
        bagsBehaviorRelay.accept([Bag]())
        bagBehaviorRelay.accept(Bag())
    }

    func updateAccountName(name: String) {
        accountBehaviorRelay.accept(Account(uuid: accountBehaviorRelay.value.uuid,
                                            mnemonic: accountBehaviorRelay.value.mnemonic,
                                            passwordHash: accountBehaviorRelay.value.passwordHash,
                                            name: name))
    }

    func generateNextBag() -> Bool {
        guard walletBehaviorRelay.value.addressCount < Wallet.maxAddressCount else { return false }
        pri_updateWallet(index: walletBehaviorRelay.value.addressIndex, count: walletBehaviorRelay.value.addressCount + 1)
        pri_updateBags()
        return true
    }

    func selectBag(index: Int) -> Bool {
        guard index < walletBehaviorRelay.value.addressCount else { return false }
        guard index != walletBehaviorRelay.value.addressIndex else { return true }
        pri_updateWallet(index: index, count: walletBehaviorRelay.value.addressCount)
        pri_updateBag()
        return true
    }

    func account() -> Account {
        return accountBehaviorRelay.value
    }

    func bag() -> Bag {
        return bagBehaviorRelay.value
    }

    func selectBagIndex() -> Int {
        return walletBehaviorRelay.value.addressIndex
    }

    func canGenerateNextBag() -> Bool {
        return walletBehaviorRelay.value.addressCount < Wallet.maxAddressCount
    }
}

// pri function
extension HDWalletManager {

    fileprivate func pri_updateWallet(index: Int, count: Int) {
        walletBehaviorRelay.accept(Wallet(addressIndex: index, addressCount: count))

        if let data = walletBehaviorRelay.value.toJSONString()?.data(using: .utf8) {
            do {
                try fileHelper.writeData(data, relativePath: type(of: self).saveKey)
            } catch let error {
                assert(false, error.localizedDescription)
            }
        }
    }

    fileprivate func pri_updateBags() {
        bagsBehaviorRelay.accept(pri_generateBags(mnemonic: accountBehaviorRelay.value.mnemonic, count: walletBehaviorRelay.value.addressCount))
    }

    fileprivate func pri_updateBag() {
        bagBehaviorRelay.accept(bagsBehaviorRelay.value[walletBehaviorRelay.value.addressIndex])
    }

    private func pri_generateBags(mnemonic: String, count: Int) -> [Bag] {
        let seed = Mnemonic.createBIP39Seed(mnemonic: mnemonic).toHexString()
        let keys = NSMutableArray()
        for index in 0..<count {
            if let (secretKey, publicKey, address) = HDBip.accountsForIndex(index, seed: seed) {
                let key = Bag(secretKey: secretKey, publicKey: publicKey, address: Address(string: address))
                keys.add(key)
            }
        }
        return keys as! [Bag]
    }
}

extension HDWalletManager {

    struct Account {
        let uuid: String
        let mnemonic: String
        let passwordHash: String
        fileprivate(set) var name: String

        init(uuid: String, mnemonic: String, passwordHash: String, name: String) {
            self.uuid = uuid
            self.mnemonic = mnemonic
            self.passwordHash = passwordHash
            self.name = name
        }
    }

    struct Bag {
        let secretKey: String
        let publicKey: String
        let address: Address

        init(secretKey: String = "nil", publicKey: String = "nil", address: Address = Address(string: "nil")) {
            self.secretKey = secretKey
            self.publicKey = publicKey
            self.address = address
        }
    }

    struct Wallet: Mappable {

        static let maxAddressCount = 10

        fileprivate(set) var addressIndex: Int = 0
        fileprivate(set) var addressCount: Int = 1

        init(addressIndex: Int = 0, addressCount: Int = 1) {
            self.addressIndex = addressIndex
            self.addressCount = addressCount
        }

        init?(map: Map) {}

        mutating func mapping(map: Map) {
            addressIndex <- map["addressIndex"]
            addressCount <- map["addressCount"]
        }
    }
}

extension FileHelper {
    static var appPathComponent = "app"
    static var accountPathComponent: String {
        return HDWalletManager.instance.accountBehaviorRelay.value.uuid
    }
}
