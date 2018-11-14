//
//  WebHandler.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

struct WebHandler {
    #if DEBUG || TEST
    fileprivate static var browserUrlString: String {
        if DebugService.instance.browserUseOnlineUrl {
            return "https://testnet.vite.net"
        } else {
            if let url = URL(string: DebugService.instance.browserCustomUrl) {
                return url.absoluteString
            } else {
                return DebugService.instance.browserDefaultTestEnvironmentUrl.absoluteString
            }
        }
    }
    #else
    fileprivate static let browserUrlString = "https://testnet.vite.net"
    #endif

    static func open(_ url: URL) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        guard let rootVC = appDelegate.window?.rootViewController else { fatalError() }
        var top = rootVC
        while let presentedViewController = top.presentedViewController {
            top = presentedViewController
        }

        let string = appendQuery(urlString: url.absoluteString)
        let ret = URL(string: string)!
        let safariViewController = SafariViewController(url: ret)
        top.present(safariViewController, animated: true, completion: nil)
    }

    static func openTranscationDetailPage(hash: String) {
        let host = appendLanguagePath(urlString: browserUrlString)
        let string = appendQuery(urlString: "\(host)/transaction/\(hash)")
        let url = URL(string: string)!
        open(url)
    }

    static func openAddressDetailPage(address: String) {
        let host = appendLanguagePath(urlString: browserUrlString)
        let string = appendQuery(urlString: "\(host)/account/\(address)")
        let url = URL(string: string)!
        open(url)
    }


    fileprivate static func appendLanguagePath(urlString: String) -> String {
        if LocalizationService.sharedInstance.currentLanguage == .chinese {
            return "\(urlString)/zh"
        } else {
            return urlString
        }
    }

    fileprivate static func appendQuery(urlString: String) -> String {
        let querys = ["version": Bundle.main.versionNumber,
                      "channel": Constants.appDownloadChannel.rawValue,
                      "address": HDWalletManager.instance.bag?.address.description ?? ""]
        var string = urlString
        for (key, value) in querys {
            let separator = string.contains("?") ? "&" : "?"
            string = string.appending(separator)
            string = string.appending(key)
            string = string.appending("=")
            string = string.appending(value)
        }
        return string
    }
}
