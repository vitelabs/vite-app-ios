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

extension UIViewController {
    func showChangeLanguageList(isSettingPage: Bool = false) {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel.key.localized(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let languages: [Language] = SettingDataService.sharedInstance.getSupportedLanguages()
        for element in languages {
            let action = UIAlertAction(title: element.displayName, style: .destructive, handler: {_ in
                _ = SetLanguage(element.name)
                if isSettingPage {
                    NotificationCenter.default.post(name: .languageChangedInSetting, object: nil)
                }
            })
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

class LocalizationService {
    private let userDefaults = UserDefaults.standard
    private var localizationDic: NSDictionary?

    // Supported Languages
    private var availableLanguagesArray = ["DeviceLanguage", "en", "zh-Hans"]
    static let map = [
        "en": "English",
        "zh-Hans": "中文",
    ]

    private let kSaveLanguageDefaultKey = "kSaveLanguageDefaultKey"

    // MARK: - Public properties
    var updatedLanguage: String?

    static let  sharedInstance = LocalizationService()

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
            userDefaults.set([newLanguage], forKey: UserDefaultsName.AppCurrentLanguages)
            userDefaults.synchronize()

            // runtime
            NotificationCenter.default.post(name: .languageChanged, object: nil)
            return true
        }
        return false
    }
}
