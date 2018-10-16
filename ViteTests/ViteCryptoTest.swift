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
        let ciphertext = HDWalletStorage.Wallet.encrypt(plaintext: mnemonic, encryptKey: "123456")!
        let ret = HDWalletStorage.Wallet.decrypt(ciphertext: ciphertext, encryptKey: "123456")!
        XCTAssertEqual(mnemonic, ret)
    }

    func testBlockHash() {

        let xx = "67ad905d2eb71b84d2ea669707a64ed6dbae9733da971a029ffb564ee0668dd2bd5edfac1d091d5f810504c371e4789bb5daf53bdf6994869ba02e8aa8d30103"
        let ss = Data(bytes: xx.hex2Bytes).base64EncodedString()

        let block = AccountBlock(JSONString: "{\"accountAddress\":\"vite_aac0d5bb7d5585716a8d9a0ee600d6d28cb52d6695673e8f50\",\"height\":\"1\",\"timestamp\":1539677137,\"snapshotHash\":\"8aa4d1427223ed4757a784245483501efe728d4b9675ab02249833b6f8c462b8\",\"fee\":\"0\",\"prevHash\":\"a574cef0e2a22978f194e8ac818cb7ca4c14ea3b5d14649e4c4f0723c27b1bf6\",\"data\":\"MTI=\",\"tokenId\":\"tti_5649544520544f4b454e6e40\",\"toAddress\":\"vite_aac0d5bb7d5585716a8d9a0ee600d6d28cb52d6695673e8f50\",\"amount\":\"1000000000000000000\",\"blockType\":2,\"nonce\":\"jnrqnJpfOb4=\",\"hash\":\"cb4cc0b762bd86c95941f45a8d69d004e7c558bc27fd5204cfc504b9082f383a\",\"publicKey\":\"6RyGDGPQH21KkpAZcZB6chA+i6qH+IeGZfWk3vnsejY=\",\"signature\":\"r9JcJLiZGhFK6+bCLmcfu2W5yIPDbm2BpVWJaokkeiOebGe2WSq94jxfvF/UI40/hOWhnlWMSvXTgmnnt8P7Bw==\"}")!

        let (hash, signature) = AccountBlock.sign(accountBlock: block,
                                                  secretKeyHexString: "39ad24b209000da30661d62b017e61640ae6c44531b6d603131477bd2f4841d6",
                                                  publicKeyHexString: "e91c860c63d01f6d4a92901971907a72103e8baa87f8878665f5a4def9ec7a36")
        print(hash)
        print(signature)


    }
}
