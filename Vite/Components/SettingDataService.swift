//
//  SettingDataService.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

class SettingDataService {
    static let sharedInstance = SettingDataService()

    func getCurrentLanguage() -> Language {
        if LocalizationService.sharedInstance.updatedLanguage != nil {
            return Language(name: LocalizationService.sharedInstance.updatedLanguage!)
        }

        if let languageName = Bundle.main.preferredLocalizations.first {
            return Language(name: languageName)
        }
        return Language(name: "en")
    }
}
