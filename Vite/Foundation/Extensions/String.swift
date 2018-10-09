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

    func filterWhitespacesAndNewlines() -> String {
        var temp = self.trimmingCharacters(in: .whitespacesAndNewlines)
        temp = temp.replacingOccurrences(of: "\n", with: "")
        temp = temp.replacingOccurrences(of: "\r", with: "")
        return temp
    }

    func toEncryptKey() -> String {
        return self.md5().md5()
    }

}
