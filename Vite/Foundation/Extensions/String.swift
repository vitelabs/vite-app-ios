//
//  String.swift
//  Vite
//
//  Created by Water on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

extension String {

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return LocalizationStr(self)
            //NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
