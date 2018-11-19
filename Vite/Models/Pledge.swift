//
//  Pledge.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

struct Pledge: Mappable {

    fileprivate(set) var beneficialAddress = Address()
    fileprivate(set) var amount = Balance()
    fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    fileprivate(set) var withdrawHeight = BigInt(0)

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        beneficialAddress <- (map["beneficialAddr"], JSONTransformer.address)
        amount <- (map["amount"], JSONTransformer.balance)
        timestamp <- (map["withdrawTime"], JSONTransformer.timestamp)
        withdrawHeight <- (map["withdrawHeight"], JSONTransformer.bigint)
    }
}
