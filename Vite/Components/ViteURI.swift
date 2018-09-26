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
    case address(address: Address)
    case transfer(address: Address, tokenId: String?, amount: BigInt?, data: String?)
}

extension ViteURI {

    enum Key: String {
        case scheme = "vite:"
        case tokenId = "tti"
        case amount = "amount"
        case decimals = "decimals"
        case data = "data"
    }

    func string() -> String {
        var string = Key.scheme.rawValue

        switch self {
        case .address(let address):
            string = "\(string)\(address.description)?"
        case .transfer(let address, let tokenId, let amount, let data):

            string = "\(string)\(address.description)?"

            if let tokenId = tokenId {
                string.append(key: Key.tokenId.rawValue, value: tokenId)
            }

            if let amount = amount, amount != 0 {
                string.append(key: Key.amount.rawValue, value: amount.description)
            }

            if let data = data, !data.isEmpty {
                string.append(key: Key.data.rawValue, value: data.toHexString())
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
        let string = string.substring(range: NSRange(location: Key.scheme.rawValue.count, length: string.count - Key.scheme.rawValue.count))
        let array = string.components(separatedBy: "?")

        guard let addressString = array.first, Address.isValid(string: addressString) else { return nil }

        let address = Address(string: addressString)
        guard let parameterString = array.last, !parameterString.isEmpty else { return ViteURI.address(address: address) }

        let parameterArray = parameterString.components(separatedBy: "&")

        var dic = [String: String]()

        for parameter in parameterArray {
            let array = parameter.components(separatedBy: "=")
            guard array.count == 2, let key = array.first, let value = array.last else { return nil }
            dic[key] = value
        }

        let tokenId = dic[Key.tokenId.rawValue] ?? Token.Currency.vite.rawValue

        let amountString = dic[Key.amount.rawValue]
        var amount: BigInt?
        if let amountString = amountString {
            guard let a = scientificNotationStringToBigInt(amountString) else { return nil }
            amount = a
        }

        let decimalsString = dic[Key.decimals.rawValue]
        var decimals = BigInt(10).power(TokenCacheService.instance.tokenForId(Token.Currency.vite.rawValue)!.decimals)
        if let decimalsString = decimalsString {
            guard let a = scientificNotationStringToBigInt(decimalsString) else { return nil }
            decimals = a
        }

        if let a = amount {
            amount = a * decimals
        }

        var data: String?
        if let dataString = dic[Key.data.rawValue], let s = String(data: Data(bytes: dataString.hex2Bytes), encoding: .utf8) {
            data = s
        }

        return ViteURI.transfer(address: address, tokenId: tokenId, amount: amount, data: data)
    }

    static func scientificNotationStringToBigInt(_ string: String) -> BigInt? {
        var str = string
        var symbol = BigInt(1)

        if str.hasPrefix("+") {
            str = str.substring(from: 1)
        } else if str.hasPrefix("-") {
            str = str.substring(from: 1)
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

        guard let bigInt = front.toBigInt(decimals: exponent) else { return nil }
        return symbol * bigInt
    }
}

extension String {
    fileprivate mutating func append(key: String, value: String) {
        self = "\(self)\(key)=\(value)&"
    }
}
