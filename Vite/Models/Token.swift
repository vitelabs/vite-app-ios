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

    init(id: String = "", name: String = "", symbol: String = "") {
        self.id = id
        self.name = name
        self.symbol = symbol
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        symbol <- map["symbol"]
    }
}

extension Token {

    enum Currency: String {
        case vite = "tti_000000000000000000004cfd"
        case vcc = "tti_000000000000000000001111"
        case vcandy = "tti_000000000000000000002222"
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
        let string = (id as NSString).substring(from: 4) as String
        return string
    }
}
