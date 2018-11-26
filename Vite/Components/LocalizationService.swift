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
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
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

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    class func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
            Bundle.setLanguage(currentLanguage.rawValue)
            UserDefaultsService.instance.setObject(currentLanguage.rawValue, forKey: Key.language.rawValue, inCollection: Key.collection.rawValue)
        }
    }

    private init() {

        if let string = UserDefaultsService.instance.objectForKey(Key.language.rawValue, inCollection: Key.collection.rawValue) as? String,
            let l = Language(rawValue: string) {
            currentLanguage = l
            Bundle.setLanguage(string)
        } else {
            currentLanguage = getSystemLanguage()
            UserDefaultsService.instance.setObject(currentLanguage.rawValue, forKey: Key.language.rawValue, inCollection: Key.collection.rawValue)
            Bundle.setLanguage(currentLanguage.rawValue)
        }
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
}
