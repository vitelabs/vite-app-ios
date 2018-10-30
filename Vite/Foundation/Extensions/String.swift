//
//  String.swift
//  Vite
//
//  Created by Water on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Foundation
import CryptoSwift

extension String {

    //fetch substring as old
    func subStringInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    func toEncryptKey(salt: String) -> String {
        let index = salt.count / 2
        let first = (salt as NSString).substring(to: index) as String
        let second = (salt as NSString).substring(from: index) as String
        return ((self + first).sha1() + second).sha1()
    }
}
