//
//  Token.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct Token: Mappable {
    fileprivate(set) var id: String = ""
    fileprivate(set) var name: String = ""
    fileprivate(set) var symbol: String = ""

    var placeholdIconImage: UIImage {
        return R.image.icon_wallet_token_default()!
    }

    var defaultIconImage: UIImage {
        // Vite
        if id == TokenID.vite.rawValue {
            return R.image.icon_wallet_token_vite()!
        } else {
            return placeholdIconImage
        }
    }

    init(id: String = "", name: String = "", symbol: String = "") {
        self.id = id
        self.name = name
        self.symbol = symbol
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["TokenTypeId"]
        name <- map["TokenName"]
        symbol <- map["TokenSymbol"]
    }
}

extension Token {

    enum TokenID: String {
        case vite = "tti_000000000000000000004cfd"
    }

    static let defaultTokens: [Token] = [makeViteToken()]

    private static func makeViteToken() -> Token {
        return Token(id: TokenID.vite.rawValue, name: "vite", symbol: "VITE")
    }
}
