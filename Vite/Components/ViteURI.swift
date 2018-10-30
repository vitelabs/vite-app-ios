//
//  ViteURI.swift
//  Vite
//
//  Created by Stone on 2018/9/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import BigInt

enum ViteURI {
    case transfer(address: Address, tokenId: String?, amountString: String?, decimalsString: String?, data: String?)
}

extension ViteURI {

    enum Key: String {
        case scheme = "vite:"
        case tokenId = "tti"
        case amount = "amount"
        case decimals = "decimals"
        case data = "data"
    }

    func amountToBigInt() -> BigInt? {
        switch self {
        case .transfer(_, let tokenId, let  amountString, let decimalsString, _):
            guard let amountString = amountString else { return nil }

            let tokenId = tokenId ?? TokenCacheService.instance.viteToken.id
            guard let token = TokenCacheService.instance.tokenForId(tokenId) else { return nil }

            var decimals = token.decimals
            if let decimalsString = decimalsString {
                guard let bigInt = type(of: self).scientificNotationStringToBigInt(decimalsString, decimals: 0), let d = Int(bigInt.description) else { return nil }
                decimals = d
            }

            return type(of: self).scientificNotationStringToBigInt(amountString, decimals: decimals)

        }
    }

    func string() -> String {
        var string = Key.scheme.rawValue

        switch self {
        case .transfer(let address, let tokenId, let amountString, let decimalsString, let data):

            string = "\(string)\(address.description)?"

            if let tokenId = tokenId {
                string.append(key: Key.tokenId.rawValue, value: tokenId)
            }

            if let amountString = amountString {
                string.append(key: Key.amount.rawValue, value: amountString)
            }

            if let decimalsString = decimalsString {
                string.append(key: Key.decimals.rawValue, value: decimalsString)
            }

            if let data = data, !data.isEmpty {
                var note = data
                note = note.replacingOccurrences(of: "%", with: "%25")
                note = note.replacingOccurrences(of: ":", with: "%3A")
                note = note.replacingOccurrences(of: "-", with: "%2D")
                note = note.replacingOccurrences(of: "@", with: "%40")
                note = note.replacingOccurrences(of: "/", with: "%2F")
                note = note.replacingOccurrences(of: "?", with: "%3F")
                note = note.replacingOccurrences(of: "&", with: "%26")
                note = note.replacingOccurrences(of: "=", with: "%3D")
                note = note.replacingOccurrences(of: "\\", with: "%5C")
                note = note.replacingOccurrences(of: "\"", with: "%22")
                string.append(key: Key.data.rawValue, value: "\"\(note)\"")
            }
        }

        if string.hasSuffix("?") {
            string = String(string.dropLast())
        } else if string.hasSuffix("&") {
            string = String(string.dropLast())
        }

        return string
    }

    static func parser(string: String) -> ViteURI? {
        guard string.hasPrefix(Key.scheme.rawValue) else { return nil }
        let string = String(string.dropFirst(Key.scheme.rawValue.count))
        let array = string.components(separatedBy: "?")

        guard let addressString = array.first, Address.isValid(string: addressString) else { return nil }
        let address = Address(string: addressString)

        var parameterString = ""
        if array.count == 1 {
            parameterString = ""
        } else if array.count == 2 {
            parameterString = array[1]
        } else {
            return nil
        }

        var dic = [String: String]()

        if !parameterString.isEmpty {
            let parameterArray = parameterString.components(separatedBy: "&")
            for parameter in parameterArray {
                let array = parameter.components(separatedBy: "=")
                guard array.count == 2, let key = array.first, let value = array.last else { return nil }
                dic[key] = value
            }
        }

        let tokenId = dic[Key.tokenId.rawValue] ?? TokenCacheService.instance.viteToken.id

        let amountString = dic[Key.amount.rawValue]
        if let amountString = amountString {
            guard checkFormatScientificNotationString(amountString) else { return nil }
        }

        let decimalsString = dic[Key.decimals.rawValue]
        if let decimalsString = decimalsString {
            guard checkFormatScientificNotationString(decimalsString) else { return nil }
        }

        var data: String?
        if let dataString = dic[Key.data.rawValue],
            !dataString.isEmpty,
            dataString.hasPrefix("\""),
            dataString.hasSuffix("\"") {

            var note = dataString
            note = note.replacingOccurrences(of: "%25", with: "%")
            note = note.replacingOccurrences(of: "%3A", with: ":")
            note = note.replacingOccurrences(of: "%2D", with: "-")
            note = note.replacingOccurrences(of: "%40", with: "@")
            note = note.replacingOccurrences(of: "%2F", with: "/")
            note = note.replacingOccurrences(of: "%3F", with: "?")
            note = note.replacingOccurrences(of: "%26", with: "&")
            note = note.replacingOccurrences(of: "%3D", with: "=")
            note = note.replacingOccurrences(of: "%5C", with: "\\")
            note = note.replacingOccurrences(of: "%22", with: "\"")
            note = String(note.dropFirst())
            data = String(note.dropLast())
        }

        return ViteURI.transfer(address: address, tokenId: tokenId, amountString: amountString, decimalsString: decimalsString, data: data)
    }

    static func checkFormatScientificNotationString(_ string: String) -> Bool {
        var str = string

        if str.hasPrefix("+") {
            str = String(str.dropFirst())
        } else if str.hasPrefix("-") {
            str = String(str.dropFirst())
        }

        var front: String!

        do {
            let array = str.lowercased().components(separatedBy: "e")
            if array.count == 1 {
                front = array.first
            } else if array.count == 2 {
                front = array.first
                guard let _ = Int(array.last!) else { return false }
            } else {
                return false
            }
        }

        do {
            let array = front.components(separatedBy: ".")
            if array.count == 1 {
                return array[0].isAllDigits
            } else if array.count == 2 {
                return array[0].isAllDigits && array[0].isAllDigits
            } else {
                return false
            }
        }
    }

    static func scientificNotationStringToBigInt(_ string: String, decimals: Int) -> BigInt? {
        var str = string
        var symbol = BigInt(1)

        if str.hasPrefix("+") {
            str = String(str.dropFirst())
        } else if str.hasPrefix("-") {
            str = String(str.dropFirst())
            symbol *= BigInt(-1)
        }

        var exponent = 0
        var front: String!

        do {
            let array = str.lowercased().components(separatedBy: "e")
            if array.count == 1 {
                front = array.first
            } else if array.count == 2 {
                front = array.first
                guard let a = Int(array.last!) else { return nil }
                exponent = a
            } else {
                return nil
            }
        }

        guard let bigInt = front.toBigInt(decimals: exponent + decimals) else { return nil }
        return symbol * bigInt
    }
}

extension String {

    fileprivate mutating func append(key: String, value: String) {
        self = "\(self)\(key)=\(value)&"
    }

    fileprivate var isAllDigits: Bool {
        var isAll = true
        let numbers = Character("0")...Character("9")

        for eachChar in self where !numbers.contains(eachChar) {
            isAll = false
            break
        }

        return isAll
    }

}
