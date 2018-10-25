//
//  WKWebViewJSBridgeEngine+Transaction.swift
//  Vite
//
//  Created by Water on 2018/10/23.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import SwiftyJSON

public extension WKWebViewJSBridgeEngine {
    @objc func jsapi_sendTransaction(parameters: [String: String], callbackID: String) {

        let str = parameters["data"]
        let json = JSON(parseJSON: str ?? "{}").dictionaryValue
        let tokenDic = json["token"]?.dictionaryValue
        let address = json["address"]?.stringValue ?? ""
        let amount = json["amount"]?.stringValue
        let note = json["note"]?.stringValue

        let token = Token(JSON: tokenDic!)

        let sendViewController = SendViewController.init(token: token!, address: Address.init(string: address), amount: amount?.toBigInt(decimals: 2), note: note)
        Route.getTopVC()?.navigationController?.pushViewController(sendViewController, animated: true)
    }
}
