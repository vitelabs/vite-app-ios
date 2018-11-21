//
//  KeychainService.swift
//  Vite
//
//  Created by Stone on 2018/10/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import KeychainSwift
import ObjectMapper

class KeychainService {
    static let instance = KeychainService()

    private let keychain = KeychainSwift.init(keyPrefix: "vite")
    private init() {
        if let jsonString = keychain.get(Key.currentWallet.rawValue) {
            currentWallet = Wallet(JSONString: jsonString)
        }
    }

    private func pri_set(_ value: String?, for key: Key) {
        if let value = value {
            keychain.set(value, forKey: key.rawValue, withAccess: .accessibleAlways)
        } else {
            keychain.delete(key.rawValue)
        }
    }

    enum Key: String {
        #if ENTERPRISE
        case currentWallet = "currentWallet.ep"
        #else
        case currentWallet
        #endif
    }

    fileprivate(set) var currentWallet: Wallet? {
        didSet {
            guard oldValue?.toJSONString() != currentWallet?.toJSONString() else { return }
            pri_set(currentWallet?.toJSONString(), for: Key.currentWallet)
        }
    }

    func setCurrentWallet(uuid: String, encryptKey: String) {
        currentWallet = Wallet(uuid: uuid, encryptKey: encryptKey)
    }

    func clearCurrentWallet() {
        currentWallet = nil
    }
}

extension KeychainService {

    struct Wallet: Mappable {

        fileprivate(set) var uuid: String!
        fileprivate(set) var encryptKey: String!

        init?(map: Map) {}

        init(uuid: String, encryptKey: String) {
            self.uuid = uuid
            self.encryptKey = encryptKey
        }

        mutating func mapping(map: Map) {
            uuid <- map["uuid"]
            encryptKey <- map["encryptKey"]
        }
    }
}
