//
//  NotificationName.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

extension Notification.Name {
    // Need to update UI
    static let languageChanged = NSNotification.Name(rawValue: "Vite_APPLanguageChanged")
    static let languageChangedInSetting = NSNotification.Name(rawValue: "Vite_APPLanguageChangedInSetting")

    // account
    static let createAccountSuccess = NSNotification.Name(rawValue: "Vite_createAccountSuccess")
    static let logoutDidFinish = NSNotification.Name(rawValue: "Vite_logoutDidFinish")
    static let loginDidFinish = NSNotification.Name(rawValue: "Vite_loginDidFinish")
}
