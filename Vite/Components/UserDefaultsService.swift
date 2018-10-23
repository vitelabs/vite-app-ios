//
//  UserDefaultsService.swift
//  Vite
//
//  Created by Stone on 2018/10/22.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

class UserDefaultsService {
    static let instance = UserDefaultsService()
    typealias DictionaryType = [String: Any]
    fileprivate static let userDefaultsKey = "com.vite.user.defaults"
    fileprivate var dic: DictionaryType

    private init() {
        if let dic = UserDefaults.standard.object(forKey: type(of: self).userDefaultsKey) as? DictionaryType {
            self.dic = dic
        } else {
            self.dic = [:]
        }
    }

    func setObject(_ object: Any, forKey key: String, inCollection collection: String) {

        var collectionDic = DictionaryType()
        if let dic = dic[collection] as? DictionaryType {
            collectionDic = dic
        }

        collectionDic[key] = object
        dic[collection] = collectionDic

        UserDefaults.standard.set(dic, forKey: type(of: self).userDefaultsKey)
        UserDefaults.standard.synchronize()
    }

    func objectForKey(_ key: String, inCollection collection: String) -> Any? {

        var collectionDic = DictionaryType()
        if let dic = dic[collection] as? DictionaryType {
            collectionDic = dic
        } else {
            return nil
        }

        return collectionDic[key]
    }
}
