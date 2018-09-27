//
//  InputLimitsHelper.swift
//  Vite
//
//  Created by Stone on 2018/9/27.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

struct InputLimitsHelper {

    static func allowText(_ text: String, shouldChangeCharactersIn range: NSRange, replacementString string: String, maxCount: Int) -> Bool {
        return text.utf8.count + string.utf8.count - range.length <= maxCount
    }

    static func allowDecimalPointWithDigitalText(_ text: String, shouldChangeCharactersIn range: NSRange, replacementString string: String, decimals: Int) -> (Bool, String) {

        if string.count > 1 {
            (text as NSString).replacingCharacters(in: range, with: "")
            return (false, text)
        }

        let replacedText = text.replacingOccurrences(of: ",", with: ".")
        let string = string.replacingOccurrences(of: ",", with: ".")

        var isHaveDian = (replacedText as NSString).range(of: ".").location != NSNotFound

        if let single = string.first {
            let numbers = Character("0")...Character("9")
            if numbers.contains(single) || single == "." {

                if replacedText.isEmpty {
                    if single == "." {
                        (text as NSString).replacingCharacters(in: range, with: "")
                        return (false, text)
                    }
                } else if replacedText.count == 1 {
                    if replacedText == "0" && single != "." {
                        return (false, text)
                    }
                }

                if single == "." {

                    if isHaveDian {
                        (text as NSString).replacingCharacters(in: range, with: "")
                        return (false, text)
                    } else {
                        isHaveDian = true
                        return (true, text)
                    }

                } else {

                    if isHaveDian {
                        let ran = (replacedText as NSString).range(of: ".")
                        let tt = range.location - ran.location
                        if tt <= decimals {
                            return (true, text)
                        } else {
                            return (false, text)
                        }
                    } else {
                        return (true, text)
                    }
                }

            } else {
                (text as NSString).replacingCharacters(in: range, with: "")
                return (false, text)
            }
        } else {
            return (true, text)
        }
    }
}
