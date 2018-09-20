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
        id <- map["id"]
        name <- map["name"]
        symbol <- map["symbol"]
        decimals <- map["decimals"]
    }
}

extension Token {
    var backgroundColors: [UIColor] {
        return TokenCacheService.instance.backgroundColorsForId(id)
    }

    var icon: Token.Icon {
        return TokenCacheService.instance.iconForId(id)
    }
}

extension Token {

    enum Currency: String {
        case vite = "tti_000000000000000000004cfd"
        case vcc = "tti_111000000000000000001111"
        case vcandy = "tti_222000000000000000002222"
    }

    enum Icon {
        case url(url: URL)
        case image(image: UIImage)

        func putIn(_ imageView: UIImageView) {
            switch self {
            case .image(let image):
                imageView.image = image
            case .url(let url):
                fatalError("\(url) Currently not supported!")
            }
        }
    }
}

extension Token {
    static func idStriped(_ id: String) -> String {
        guard id.count == 28 else { return "" }
        let string = (id as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        return string
    }
}
