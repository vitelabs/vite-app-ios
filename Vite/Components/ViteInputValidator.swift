//
//  ViteInputValidator.swift
//  Vite
//
//  Created by Water on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import Foundation
import UIKit

class ViteInputValidator: NSObject {

    class func handleMnemonicStrSpacing(_ str: String) -> String {
        let components = str.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

   class func isValidWalletName(str: String) -> Bool {
        let temp = str.trimmingCharacters(in: .whitespaces)
        // chinese english _
        let pattern1 = "^[a-zA-Z0-9_\u{4e00}-\u{9fa5}]+$"
        let regex1 = try! NSRegularExpression(pattern: pattern1, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex1.matches(in: temp, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: temp.count))

        return !matches.isEmpty
    }

    class func isValidWalletNameCount(str: String) -> Bool {
        return str.utf8.count <= 32
    }

    class func isValidWalletPassword(str: String) -> Bool {
        let temp = str.trimmingCharacters(in: .whitespaces)
        let pattern1 = "^[0-9]{6}"
        let regex1 = try! NSRegularExpression(pattern: pattern1, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex1.matches(in: temp, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: temp.count))

        return !matches.isEmpty
    }
}
