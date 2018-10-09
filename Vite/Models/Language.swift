//
//   Language.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

class Language: Equatable {

    let name: String
    let displayName: String

    // This function will be called many times.
    init(name: String) {
        self.name = name
        if let displayName = LocalizationService.availableLocalization[name] {
            self.displayName = displayName
        } else {
            self.displayName = "Undefined"
        }
    }

    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.name == rhs.name
    }
}
