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

    fileprivate(set) var height = BigInt(0)
    fileprivate(set) var status = Transaction.Status.error
    fileprivate(set) var isSnapshotted = false

    init?(map: Map) {

    }

    init() {

    }

    mutating func mapping(map: Map) {
        height <- (map["Height"], JSONTransformer.bigint)
        status <- map["Status"]
        isSnapshotted <- map["IsSnapshotted"]
    }

    mutating func setHeight(_ height: BigInt) {
        self.height = height
    }
}
