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
    case transfer(address: Address, tokenId: String?, amount: BigInt?, note: String?)
}

extension ViteURI {

    enum Key: String {
        case scheme = "vite:"
        case tokenId = "tti"
        case amount = "amount"
        case note = "note"
    }

    func string() -> String {
        var string = Key.scheme.rawValue

        switch self {
        case .address(let address):
            string = "\(string)\(address.description)?"
        case .transfer(let address, let tokenId, let amount, let note):

            string = "\(string)\(address.description)?"

            if let tokenId = tokenId {
                string.append(key: Key.tokenId.rawValue, value: tokenId)
            }

            if let amount = amount {
                string.append(key: Key.amount.rawValue, value: amount.description)
            }

            if let note = note {
                string.append(key: Key.note.rawValue, value: note)
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

        var keys = [String]()
        var dic = [String: String]()

        for parameter in parameterArray {
            let array = parameter.components(separatedBy: "=")
            guard array.count == 2, let key = array.first, let value = array.last else { return nil }
            keys.append(key)
            dic[key] = value
        }

        let tokenId = dic[Key.tokenId.rawValue] ?? Token.Currency.vite.rawValue
        let amountString = dic[Key.amount.rawValue]
        var amount: BigInt? = nil
        if let amountString = amountString {
            guard let a = BigInt(amountString) else { return nil }
            amount = a
        }

        let note = dic[Key.note.rawValue]
        return ViteURI.transfer(address: address, tokenId: tokenId, amount: amount, note: note)
    }
}

extension String {
    fileprivate mutating func append(key: String, value: String) {
        self = "\(self)\(key)=\(value)&"
    }
}
