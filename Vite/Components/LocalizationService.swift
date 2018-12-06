//
//  Localizator.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import ViteUtils

extension UIViewController {
    func showChangeLanguageList(isSettingPage: Bool = false) {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let languages  = ViteLanguage.allLanguages
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

    static let  sharedInstance = LocalizationService()
    fileprivate enum Key: String {
        case collection = "Localization"
        case language = "Language"
    }

    fileprivate var localizationHash: [String: Any] = [:]
    fileprivate var cacheTextDic: [String: String] = [:]
    fileprivate let fileHelper = FileHelper(.library, appending: "\(FileHelper.appPathComponent)/Localization")

    func updateLocalizableIfNeeded(localizationHash: [String: Any]) {
        let language = currentLanguage
        self.localizationHash = localizationHash
        guard let current = localizationHash[language.rawValue] as? [String: Any],
            let hash = current["hash"] as? String, let build = current["build"] as? Int else { return }
        guard Bundle.main.buildNumberInt <= build, cacheFileHash(language: language) != hash else { return }

        COSProvider.instance.getLocalizable(language: language) { (result) in
            switch result {
            case .success(let jsonString):
                plog(level: .debug, log: "get \(language.rawValue) localizable finished", tag: .getConfig)
                if let string = jsonString,
                    let data = string.data(using: .utf8) {
                    if let error = self.fileHelper.writeData(data, relativePath: self.cacheFileName(language: language)) {
                        assert(false, error.localizedDescription)
                    }
                    self.reloadCacheLocalization()
                }
            case .failure(let error):
                plog(level: .warning, log: error.message, tag: .getConfig)
                GCD.delay(2, task: { self.updateLocalizableIfNeeded(localizationHash: self.localizationHash) })
            }
        }

    }

    var currentLanguage: ViteLanguage = .base {
        didSet {
            guard currentLanguage != oldValue else { return }
            UserDefaultsService.instance.setObject(currentLanguage.rawValue, forKey: Key.language.rawValue, inCollection: Key.collection.rawValue)
            reloadCacheLocalization()
            updateLocalizableIfNeeded(localizationHash: self.localizationHash)
        }
    }

    private init() {
        if let string = UserDefaultsService.instance.objectForKey(Key.language.rawValue, inCollection: Key.collection.rawValue) as? String,
            let l = ViteLanguage(rawValue: string) {
            currentLanguage = l
        } else {
            currentLanguage = getSystemLanguage()
            UserDefaultsService.instance.setObject(currentLanguage.rawValue, forKey: Key.language.rawValue, inCollection: Key.collection.rawValue)
        }
        object_setClass(Bundle.main, AnyLanguageBundle.self)
        reloadCacheLocalization()
    }
}

private class AnyLanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {

        if let ret = LocalizationService.sharedInstance.cacheTextDic[key] {
            return ret
        }

        guard let path = Bundle.main.path(forResource: LocalizationService.sharedInstance.currentLanguage.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path) else {
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

// MARK: private function
extension LocalizationService {
    fileprivate func getSystemLanguage() -> ViteLanguage {
        if let code = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String {
            if code.hasPrefix("zh") {
                return .chinese
            }
        }
        return .base
    }

    fileprivate func reloadCacheLocalization() {
        let sandboxPath = fileHelper.rootPath + "/\(currentLanguage.rawValue).strings"
        if FileManager.default.fileExists(atPath: sandboxPath),
            let ret = NSDictionary(contentsOfFile: sandboxPath) as? [String: String] {
            cacheTextDic = ret
        } else {
            cacheTextDic = [:]
        }
        NotificationCenter.default.post(name: .localizedStringChanged, object: nil, userInfo: ["language": currentLanguage, "cacheTextDic": cacheTextDic])
    }

    fileprivate func cacheFileHash(language: ViteLanguage) -> String? {
        if let data = self.fileHelper.contentsAtRelativePath(cacheFileName(language: language)),
            let string = String(data: data, encoding: .utf8) {
            return string.md5()
        } else {
            return nil
        }
    }

    fileprivate func cacheFileName(language: ViteLanguage) -> String {
        return "\(language.rawValue).strings"
    }
}
