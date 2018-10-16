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
        let block = AccountBlock(JSONString: "{\"accountAddress\":\"vite_a17465557d554fd27ff958887082f147054e0d6f75762e25cb\",\"height\":\"1\",\"timestamp\":1539669939,\"snapshotHash\":\"17c5712f0feb83c3a25a63b55979f1991d5c41bf9450849eaebfe39e54076393\",\"fee\":\"0\",\"prevHash\":\"0000000000000000000000000000000000000000000000000000000000000000\",\"blockType\":4,\"fromBlockHash\":\"382c9d11894aa45d18bb02edf4b520a281341e686915c750adbbb0655c8ba6ec\",\"nonce\":\"xjpCTkxYBfA=\",\"publicKey\":\"79e0fbc083681e636fef9b389d91c5700ae5d401438158e5c7798b76232cdf88\",\"hash\":\"2b39c5c1e3f70eee84679914aedea5585b3990c2d922cd7f8d31b49b759ab8eb\",\"signature\":\"cad7e04fe1a1184df1394d73cee27ef79b6b6a9b52a82b9bcf546cd9e96adf53423149a33a856c6220f7745bd7c1512bd1e6fc21f9a4dd878dd50ac44e596200\"}")!

        let (hash, signature) = AccountBlock.sign(accountBlock: block,
                                                  secretKeyHexString: "dcb735c454777a697c417472a5dc46333fd738c062c26f2dc6bce8a972dece1f",
                                                  publicKeyHexString: "79e0fbc083681e636fef9b389d91c5700ae5d401438158e5c7798b76232cdf88")
        print(hash)
        print(signature)
    }
}
