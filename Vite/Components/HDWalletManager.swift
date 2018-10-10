//
//  HDWalletManager.swift
//  Vite
//
//  Created by Stone on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Vite_HDWalletKit
import ObjectMapper
import RxSwift
import RxCocoa

final class HDWalletManager {
    static let instance = HDWalletManager()
    private init() {}

    lazy var walletDriver: Driver<HDWalletStorage.Wallet> = self.walletBehaviorRelay.asDriver().filterNil()
    lazy var bagsDriver: Driver<[Bag]> = self.bagsBehaviorRelay.asDriver()
    lazy var bagDriver: Driver<Bag> = self.bagBehaviorRelay.asDriver().filterNil()

    fileprivate var walletBehaviorRelay: BehaviorRelay<HDWalletStorage.Wallet?> = BehaviorRelay(value: nil)
    fileprivate var bagsBehaviorRelay = BehaviorRelay(value: [Bag]())
    fileprivate var bagBehaviorRelay: BehaviorRelay<Bag?> = BehaviorRelay(value: nil)

    fileprivate let storage = HDWalletStorage()
    fileprivate(set) var mnemonic: String?
    fileprivate var encryptKey: String?

    fileprivate static let maxAddressCount = 10

    func updateName(name: String) {
        guard let wallet = storage.updateCurrentWalletName(name) else { return }
        walletBehaviorRelay.accept(wallet)
    }

    func generateNextBag() -> Bool {
        guard let wallet = walletBehaviorRelay.value else { return false }
        guard wallet.addressCount < type(of: self).maxAddressCount else { return false }
        pri_update(addressIndex: wallet.addressIndex, addressCount: wallet.addressCount + 1)
        pri_updateBags()
        return true
    }

    func selectBag(index: Int) -> Bool {
        guard let wallet = walletBehaviorRelay.value else { return false }
        guard index < wallet.addressCount else { return false }
        guard index != wallet.addressIndex else { return true }
        pri_update(addressIndex: index, addressCount: wallet.addressCount)
        pri_updateBag()
        return true
    }

    var wallets: [HDWalletStorage.Wallet] {
        return storage.wallets
    }

    var wallet: HDWalletStorage.Wallet? {
        return storage.currentWallet
    }

    var bag: Bag? {
        return bagBehaviorRelay.value
    }

    var selectBagIndex: Int {
        return walletBehaviorRelay.value?.addressIndex ?? 0
    }

    var canGenerateNextBag: Bool {
        guard let wallet = walletBehaviorRelay.value else { return false }
        return wallet.addressCount < type(of: self).maxAddressCount
    }
}

// MARK: - Settings
extension HDWalletManager {
    func setIsRequireAuthentication(_ isRequireAuthentication: Bool) {
        guard let wallet = storage.updateCurrentWallet(isRequireAuthentication: isRequireAuthentication) else { return }
        walletBehaviorRelay.accept(wallet)
    }

    func setIsAuthenticatedByBiometry(_ isAuthenticatedByBiometry: Bool) {
        guard let wallet = storage.updateCurrentWallet(isAuthenticatedByBiometry: isAuthenticatedByBiometry) else { return }
        walletBehaviorRelay.accept(wallet)
    }

    func setIsTransferByBiometry(_ isTransferByBiometry: Bool) {
        guard let wallet = storage.updateCurrentWallet(isTransferByBiometry: isTransferByBiometry) else { return }
        walletBehaviorRelay.accept(wallet)
    }

    var isRequireAuthentication: Bool {
        return storage.currentWallet?.isRequireAuthentication ?? false
    }

    var isAuthenticatedByBiometry: Bool {
        return storage.currentWallet?.isAuthenticatedByBiometry ?? false
    }

    var isTransferByBiometry: Bool {
        return storage.currentWallet?.isTransferByBiometry ?? false
    }
}

// MARK: - login & logout
extension HDWalletManager {

    func addAddLoginWallet(uuid: String, name: String, mnemonic: String, encryptKey: String) {
        let wallet = storage.addAddLoginWallet(uuid: uuid, name: name, mnemonic: mnemonic, encryptKey: encryptKey, needRecoverAddresses: false)
        self.mnemonic = mnemonic
        self.encryptKey = encryptKey
        pri_updateWallet(wallet)
    }

    func importAddLoginWallet(uuid: String, name: String, mnemonic: String, encryptKey: String) {
        let wallet = storage.addAddLoginWallet(uuid: uuid, name: name, mnemonic: mnemonic, encryptKey: encryptKey, needRecoverAddresses: true)
        self.mnemonic = mnemonic
        self.encryptKey = encryptKey
        pri_updateWallet(wallet)
    }

    func loginWithUuid(_ uuid: String, encryptKey: String) -> Bool {
        guard let (wallet, mnemonic) = storage.login(encryptKey: encryptKey, uuid: uuid) else { return false }
        self.mnemonic = mnemonic
        self.encryptKey = encryptKey
        pri_updateWallet(wallet)
        return true
    }

    func loginCurrent(encryptKey: String) -> Bool {
        guard let (wallet, mnemonic) = storage.login(encryptKey: encryptKey) else { return false }
        self.mnemonic = mnemonic
        self.encryptKey = encryptKey
        pri_updateWallet(wallet)
        return true
    }

    func logout() {
        storage.logout()
        mnemonic = nil
        encryptKey = nil
        walletBehaviorRelay.accept(nil)
        bagsBehaviorRelay.accept([Bag]())
        bagBehaviorRelay.accept(nil)
    }

    func deleteAllWallets() {
        storage.deleteAllWallets()
        mnemonic = nil
        encryptKey = nil
        walletBehaviorRelay.accept(nil)
        bagsBehaviorRelay.accept([Bag]())
        bagBehaviorRelay.accept(nil)
    }

    func verifyPassword(_ password: String) -> Bool {
        guard let uuid = storage.currentWalletUuid else { return false }
        let encryptKey = password.toEncryptKey(salt: uuid)
        return encryptKey == self.encryptKey
    }

    var canLock: Bool {
        return storage.currentWallet != nil
    }

    var isEmpty: Bool {
        return storage.wallets.isEmpty
    }
}

// MARK: - private function
extension HDWalletManager {

    fileprivate func pri_updateWallet(_ wallet: HDWalletStorage.Wallet) {
        walletBehaviorRelay.accept(wallet)
        pri_updateBags()
        pri_updateBag()
        pri_recoverAddressesIfNeeded(wallet.uuid)
    }

    fileprivate func pri_recoverAddressesIfNeeded(_ uuid: String) {
        guard let wallet = self.walletBehaviorRelay.value else { return }
        guard uuid == wallet.uuid else { return }
        guard wallet.needRecoverAddresses else { return }

        pri_allAddresses { (addresses) in
            Provider.instance.recoverAddresses(addresses, completion: { [weak self] (result) in
                guard let `self` = self else { return }
                guard let wallet = self.walletBehaviorRelay.value else { return }
                guard uuid == wallet.uuid else { return }
                switch result {
                case .success(let count):
                    let current = wallet.addressCount
                    self.pri_update(addressIndex: wallet.addressIndex, addressCount: max(current, count), needRecoverAddresses: false)
                    self.pri_updateBags()
                    self.pri_updateBag()
                case .error:
                    GCD.delay(3, task: { self.pri_recoverAddressesIfNeeded(uuid) })
                }
            })
        }
    }

    fileprivate func pri_update(addressIndex: Int, addressCount: Int, needRecoverAddresses: Bool? = nil) {
        guard let wallet = storage.updateCurrentWallet(addressIndex: addressIndex,
                                                       addressCount: addressCount,
                                                       needRecoverAddresses: needRecoverAddresses) else { return }
        walletBehaviorRelay.accept(wallet)
    }

    fileprivate func pri_updateBags() {
        guard let mnemonic = mnemonic else { return }
        guard let wallet = walletBehaviorRelay.value else { return }
        bagsBehaviorRelay.accept(pri_generateBags(mnemonic: mnemonic, count: wallet.addressCount))
    }

    fileprivate func pri_updateBag() {
        guard let wallet = walletBehaviorRelay.value else { return }
        bagBehaviorRelay.accept(bagsBehaviorRelay.value[wallet.addressIndex])
    }

    fileprivate func pri_allAddresses(completion: @escaping ([Address]) -> Void) {
        DispatchQueue.global().async {
            guard let mnemonic = self.mnemonic else {
                completion([])
                return
            }
            let address = self.pri_generateBags(mnemonic: mnemonic, count: type(of: self).maxAddressCount).map { $0.address }
            DispatchQueue.main.async {
                completion(address)
            }
        }
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

// MARK: - Bag
extension HDWalletManager {

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
}

extension FileHelper {
    static var appPathComponent = "app"
    static var accountPathComponent: String {
        return HDWalletManager.instance.walletBehaviorRelay.value?.uuid ?? "uuid"
    }
}
