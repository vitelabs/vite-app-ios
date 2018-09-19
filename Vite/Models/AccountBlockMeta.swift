//
//  AccountBlockMeta.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import ObjectMapper
import BigInt

struct AccountBlockMeta: Mappable {

    fileprivate(set) var height: BigInt?
    fileprivate(set) var status: Transaction.Status?
    fileprivate(set) var isSnapshotted: Bool?

    init?(map: Map) {

    }

    init(height: BigInt? = nil, status: Transaction.Status? = nil, isSnapshotted: Bool? = nil) {
        self.height = height
        self.status = status
        self.isSnapshotted = isSnapshotted
    }

    mutating func mapping(map: Map) {
        height <- (map["height"], JSONTransformer.bigint)
        status <- map["status"]
        isSnapshotted <- map["isSnapshotted"]
    }

    mutating func setHeight(_ height: BigInt) {
        self.height = height
    }
}
