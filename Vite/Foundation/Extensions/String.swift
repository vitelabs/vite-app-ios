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

    func localized() -> String {
        return LocalizationStr(self)
    }

    func localized(arguments: CVarArg...) -> String {
        let format = LocalizationStr(self)
        let t = self.Localizer()

       return withVaList(arguments) { t(format, $0) }
    }
    private func Localizer() -> (_ key: String, _ params: CVaListPointer) -> String {
        return { (key: String, params: CVaListPointer) in
            let content = NSLocalizedString(key, tableName: "", comment: "")
            return NSString(format: content, arguments: params) as String
        }
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

    func pwdEncrypt() -> String {
        return self.md5().md5()
    }

    func substring(to: Int) -> String {
        return (self as NSString).substring(to: to) as String
    }

    func substring(from: Int) -> String {
        return (self as NSString).substring(from: from) as String
    }

    func toHexString() -> String {
        return hex2Bytes.toHexString()
    }
}
