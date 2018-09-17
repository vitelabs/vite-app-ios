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
        id <- map["TokenTypeId"]
        name <- map["TokenName"]
        symbol <- map["TokenSymbol"]
    }
}

extension Token {

    enum Currency: String {
        case vite = "tti_000000000000000000004cfd"
    }

    enum Icon {
        case url(url: URL)
        case local(imageResource: ImageResource)

        func putIn(_ imageView: UIImageView) {
            switch self {
            case .local(let imageResource):
                imageView.image = UIImage(resource: imageResource)
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
