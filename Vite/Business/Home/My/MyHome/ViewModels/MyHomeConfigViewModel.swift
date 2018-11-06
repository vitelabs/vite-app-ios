//
//  MyHomeConfigViewModel.swift
//  Vite
//
//  Created by Stone on 2018/11/6.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

struct MyHomeConfigViewModel: Mappable  {
    var items:[MyHomeListCellViewModel] = []

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        items <- map["items"]
    }
}
