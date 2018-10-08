//
//  ViteInputValidTest.swift
//  ViteTests
//
//  Created by Water on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import XCTest
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

    }

}

