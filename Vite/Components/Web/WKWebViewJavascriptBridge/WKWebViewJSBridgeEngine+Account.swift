//
//  WKWebViewJSBridgeEngine+Account.swift
//  Vite
//
//  Created by Water on 2018/10/23.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import SwiftyJSON

public extension  WKWebViewJSBridgeEngine {
    @objc func jsapi_loginUserInfo(parameters: [String: String], callbackID: String) {
        let responseData = HDWalletManager.instance.wallet?.name
        let message: Message = ["responseID": callbackID, "responseData": responseData ?? ""]
        self.sendResponds(message)
    }

    @objc func jsapi_isLogin(parameters: [String: String], callbackID: String) {
        let responseData = !HDWalletManager.instance.isEmpty && HDWalletManager.instance.canUnLock
        let message: Message = ["responseID": callbackID, "responseData": responseData ]
        self.sendResponds(message)
    }

    @objc func jsapi_goLoginVC(parameters: [String: String], callbackID: String) {
        let loginViewController = LoginViewController()
         Route.getTopVC()?.navigationController?.pushViewController(loginViewController, animated: true)
    }
}
