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
import Rswift

struct Token: Mappable {

    fileprivate(set) var id: String = ""
    fileprivate(set) var name: String = ""
    fileprivate(set) var symbol: String = ""
    fileprivate(set) var decimals: Int = 0

    init(id: String = "", name: String = "", symbol: String = "", decimals: Int = 0) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["tokenId"]
        name <- map["tokenName"]
        symbol <- map["tokenSymbol"]
        decimals <- map["decimals"]
    }
}

extension Token {
    var backgroundColors: [UIColor] {
        return TokenCacheService.instance.backgroundColorsForId(id)
    }

    var icon: ImageWrapper {
        return TokenCacheService.instance.iconForId(id)
    }
}

extension Token {
    static func idStriped(_ id: String) -> String {
        guard id.count == 28 else { return "" }
        let string = (id as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        return string
    }
}
