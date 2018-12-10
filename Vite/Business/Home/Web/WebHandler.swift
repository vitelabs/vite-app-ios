//
//  WebHandler.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import ViteUtils

struct WebHandler {
    #if DEBUG || TEST
    fileprivate static var browserUrlString: String {
        if DebugService.instance.browserUseOnlineUrl {
            return "https://explorer.vite.net"
        } else {
            if let url = URL(string: DebugService.instance.browserCustomUrl) {
                return url.absoluteString
            } else {
                return DebugService.instance.browserDefaultTestEnvironmentUrl.absoluteString
            }
        }
    }
    #else
    fileprivate static let browserUrlString = "https://explorer.vite.net"
    #endif

    static func open(_ url: URL) {

        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
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

    static func openSBPDetailPage(name: String) {
        let host = appendLanguagePath(urlString: browserUrlString)
        let string = appendQuery(urlString: "\(host)/SBPDetail/\(name)")
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
                      "address": HDWalletManager.instance.bag?.address.description ?? "",
                      "language": LocalizationService.sharedInstance.currentLanguage.rawValue]

        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var string = urlString
        for (key, value) in querys {
            let separator = string.contains("?") ? "&" : "?"
            string = string.appending(separator)
            string = string.appending(key.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "")
            string = string.appending("=")
            string = string.appending(value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "")
        }
        return string
    }
}
