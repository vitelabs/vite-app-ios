//
//  ViteInputValidTest.swift
//  ViteTests
//
//  Created by Water on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import XCTest
import Vite_HDWalletKit
@testable import Vite

class ViteInputValidTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWalletName() {
        let name1 = "fsdfsdf_12121####"
        XCTAssertEqual(ViteInputValidator.isValidWalletName(str: name1), false)


        let name2 = "fsdfsdf_12121你好"
        XCTAssertEqual(ViteInputValidator.isValidWalletName(str: name2), true)

        let name3 = "fsdfsdf_12121#11@"
        XCTAssertEqual(ViteInputValidator.isValidWalletName(str: name3), false)

        let name4 = "fsdfdf___asdf您好您好您好您好您好asdfs您好df_12121#11@"
        XCTAssertEqual(ViteInputValidator.isValidWalletName(str: name4), false)

        let pw1 = "12122&"
        XCTAssertEqual(ViteInputValidator.isValidWalletPassword(str: pw1), false)

        let pw2 = "121225"
        XCTAssertEqual(ViteInputValidator.isValidWalletPassword(str: pw2), true)

        let pw3 = "12122a"
        XCTAssertEqual(ViteInputValidator.isValidWalletPassword(str: pw3), false)

        let pw4 = "121"
        XCTAssertEqual(ViteInputValidator.isValidWalletPassword(str: pw4), false)

    }

    func testImportMnemonicStr() {
        var  str  = "lake clean pause frost snack step gym response demand rent retreat topple upset teach daring  wrist team destroy give afford noise fire dice female"
        str = ViteInputValidator.handleMnemonicStrSpacing(str)
        let result = Mnemonic.mnemonic_check(str)
        XCTAssertEqual(result, true)

        var  str1  = "lake clean pause frost       snack step gym           response demand rent retreat topple upset teach daring        wrist team destroy give          afford noise fire dice female"
        str1 = ViteInputValidator.handleMnemonicStrSpacing(str1)
        let result1 = Mnemonic.mnemonic_check(str1)
        XCTAssertEqual(result1, true)

        var  str2  = "lake clean pause frost       snack step gym           response demand rent retreat topple upset teach daring        \nwrist team destroy give          afford noise fire dice female\n"
        str2 = ViteInputValidator.handleMnemonicStrSpacing(str2)
        let result2 = Mnemonic.mnemonic_check(str2)
        XCTAssertEqual(result2, true)
    }

}

