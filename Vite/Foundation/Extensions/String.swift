//
//  String.swift
//  Vite
//
//  Created by Water on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Foundation

extension String {

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return LocalizationStr(self)
    }

    //fetch substring as old
    func subStringInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    static  func getAppVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return version
    }

    func substring(range: NSRange) -> String {
        return (self as NSString).substring(with: range) as String
    }
}
