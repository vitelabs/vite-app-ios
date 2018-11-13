//
//  Localizator.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

extension UIViewController {
    func showChangeLanguageList(isSettingPage: Bool = false) {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel.key.localized(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let languages  = LocalizationService.Language.allLanguages
        for language in languages {
            let action = UIAlertAction(title: language.name, style: .`default`, handler: {_ in
                guard LocalizationService.sharedInstance.currentLanguage != language else { return }
                LocalizationService.sharedInstance.currentLanguage = language
                if isSettingPage {
                    NotificationCenter.default.post(name: .languageChangedInSetting, object: nil)
                }
                NotificationCenter.default.post(name: .languageChanged, object: nil)
            })
            action.setValue(Colors.descGray, forKey: "titleTextColor")
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
             self.present(alertController, animated: true, completion: nil)
        }
    }
}

class LocalizationService {

    enum Language: String {
        case base = "en"
        case chinese = "zh-Hans"

        var name: String {
            switch self {
            case .base:
                return "English"
            case .chinese:
                return "中文"
            }
        }

        static var allLanguages: [Language] {
            return [.base, .chinese]
        }
    }

    static let  sharedInstance = LocalizationService()
    fileprivate var localizationDic: NSDictionary = NSDictionary()
    fileprivate enum Key: String {
        case collection = "Localization"
        case language = "Language"
    }

    var currentLanguage: Language = .base {
        didSet {
            guard currentLanguage != oldValue else { return }
            loadDictionaryForLanguage(currentLanguage)
            UserDefaultsService.instance.setObject(currentLanguage.rawValue, forKey: Key.language.rawValue, inCollection: Key.collection.rawValue)
        }
    }

    private init() {

        if let string = UserDefaultsService.instance.objectForKey(Key.language.rawValue, inCollection: Key.collection.rawValue) as? String,
            let l = Language(rawValue: string) {
            currentLanguage = l
        } else {
            currentLanguage = getSystemLanguage()
            UserDefaultsService.instance.setObject(currentLanguage.rawValue, forKey: Key.language.rawValue, inCollection: Key.collection.rawValue)
        }

        loadDictionaryForLanguage(currentLanguage)
    }
}

// MARK: private function
extension LocalizationService {
    fileprivate func getSystemLanguage() -> Language {
        if let code = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String {
            if code.hasPrefix("zh") {
                return .chinese
            }
        }
        return .base
    }

    fileprivate func loadDictionaryForLanguage(_ language: Language) {
        if let path = Bundle(for: object_getClass(self)!).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: language.rawValue)?.path {
            if FileManager.default.fileExists(atPath: path) {
                localizationDic = NSDictionary(contentsOfFile: path) ?? NSDictionary()
            }
        }
    }

    fileprivate func localizedStringForKey(_ key: String) -> String {
        if let localizedString = localizationDic[key] as? String {
            return localizedString
        } else {
            return key
        }
    }
}

// MARK: String extension
extension String {

    func localized() -> String {
        return LocalizationService.sharedInstance.localizedStringForKey(self)
    }

    func localized(arguments: CVarArg...) -> String {
        let format = LocalizationService.sharedInstance.localizedStringForKey(self)
        let t = self.Localizer()

        return withVaList(arguments) { t(format, $0) }
    }

    private func Localizer() -> (_ key: String, _ params: CVaListPointer) -> String {
        return { (key: String, params: CVaListPointer) in
            let content = NSLocalizedString(key, tableName: "", comment: "")
            return NSString(format: content, arguments: params) as String
        }
    }
}
