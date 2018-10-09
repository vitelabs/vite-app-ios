//
//  ViteCryptoTest.swift
//  ViteTests
//
//  Created by Stone on 2018/10/8.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import XCTest
import Vite_HDWalletKit
@testable import Vite

class ViteCryptoTest: XCTestCase {

    func testMnemonicCrypto() {

        let mnemonic = Mnemonic.randomGenerator(strength: .strong, language: .english)
        let ciphertext = HDWalletStorage.Wallet.encrypt(plaintext: mnemonic, password: "123456")!
        let ret = HDWalletStorage.Wallet.decrypt(ciphertext: ciphertext, password: "123456")!
        XCTAssertEqual(mnemonic, ret)
    }
}
