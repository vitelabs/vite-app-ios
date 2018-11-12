//
//  WebHandler.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

struct WebHandler {
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
        var host = "https://testnet.vite.net"
        if LocalizationService.sharedInstance.currentLanguage == .chinese {
            host = "\(host)/zh"
        }

        let string = appendQuery(urlString: "\(host)/transaction/\(hash)")
        let url = URL(string: string)!
        open(url)
    }

    static func openAddressDetailPage(address: String) {
        var host = "https://testnet.vite.net"
        if LocalizationService.sharedInstance.currentLanguage == .chinese {
            host = "\(host)/zh"
        }

        let string = appendQuery(urlString: "\(host)/account/\(address)")
        let url = URL(string: string)!
        open(url)
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
