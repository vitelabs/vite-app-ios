//
//  Localizator.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

func LocalizationStr(_ key: String) -> String {
    return LocalizationService.sharedInstance.localizedStringForKey(key)
}

func SetLanguage(_ language: String) -> Bool {
    return LocalizationService.sharedInstance.setLanguage(language)
}

class LocalizationService {

    // MARK: - Private properties
    private let userDefaults = UserDefaults.standard
    private var localizationDic: NSDictionary?

    // Supported Languages
    private var availableLanguagesArray = ["DeviceLanguage", "en", "zh-Hans"]
    static let map = [
        "en": "English",
        "zh-Hans": "简体中文",
    ]

    private let kSaveLanguageDefaultKey = "kSaveLanguageDefaultKey"

    // MARK: - Public properties
    var updatedLanguage: String?

    // MARK: - Singleton method
    class var sharedInstance: LocalizationService {
        struct Singleton {
            static let instance = LocalizationService()
        }
        return Singleton.instance
    }

    // MARK: - Init method
    init() {

    }

    // MARK: - Public custom getter

    func getArrayAvailableLanguages() -> [String] {
        return availableLanguagesArray
    }

    // MARK: - Private instance methods

    fileprivate func loadDictionaryForLanguage(_ newLanguage: String) -> Bool {
        let arrayExt = newLanguage.components(separatedBy: "_")
        for ext in arrayExt {
            if let path = Bundle(for: object_getClass(self)!).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: ext)?.path {
                if FileManager.default.fileExists(atPath: path) {
                    updatedLanguage = newLanguage
                    localizationDic = NSDictionary(contentsOfFile: path)
                    return true
                }
            }
        }
        return false
    }

    fileprivate func localizedStringForKey(_ key: String) -> String {
        if let dic = localizationDic {
            if let localizedString = dic[key] as? String {
                return localizedString
            } else {
                return key
            }
        } else {
            return NSLocalizedString(key, comment: key)
        }
    }

    fileprivate func setLanguage(_ newLanguage: String) -> Bool {
        if (newLanguage == updatedLanguage) || !availableLanguagesArray.contains(newLanguage) {
            return false
        }

        if loadDictionaryForLanguage(newLanguage) {
            // Update the setting. It only works when the application is restarted.
            UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()

            // runtime
            NotificationCenter.default.post(name: .languageChanged, object: nil)
            return true
        }
        return false
    }
}
