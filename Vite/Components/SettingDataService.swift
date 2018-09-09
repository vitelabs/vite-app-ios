//
//  SettingDataService.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

class SettingDataService {

    class var sharedInstance: SettingDataService {
        struct Singleton {
            static let instance = SettingDataService()
        }
        return Singleton.instance
    }

    private init() {

    }

    // MARK: Language
    func getSupportedLanguages() -> [Language] {
        let languageNames = Bundle.main.localizations
        let languages = languageNames.filter ({ (languageName) -> Bool in
            return languageName != "Base"
        }).map ({ (name) -> Language in
            return Language(name: name)
        }).sorted { (a, b) -> Bool in
            return a.name < b.name
        }

        return languages
    }

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
