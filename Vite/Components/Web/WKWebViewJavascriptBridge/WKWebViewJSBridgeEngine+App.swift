//
//  WKWebViewJSBridgeEngine+App.swift
//  Vite
//
//  Created by Water on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

public extension  WKWebViewJSBridgeEngine {
    @objc func jsapi_appChannel(parameters: [String: String], callbackID: String) {
        let responseData = Constants.appDownloadChannel
        let message = ["responseID": callbackID, "responseData": responseData]
        self.sendResponds(message)
    }
}
