//
//  StringWrapper.swift
//  Vite
//
//  Created by Stone on 2018/11/6.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

struct StringWrapper: Mappable {

    fileprivate var base: String = ""
    fileprivate var localized: [String: String] = [:]

    init(string: String) {
        self.base = string
    }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        base <- map["base"]
        localized <- map["localized"]
    }

    var string: String {
        return localized[LocalizationService.sharedInstance.currentLanguage.rawValue] ?? base
    }
}
