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
        let safariViewController = SafariViewController(url: url)
        top.present(safariViewController, animated: true, completion: nil)
    }

    static func openTranscationDetailPage(hash: String) {
        var host = "http://132.232.134.168:8080"
        if LocalizationService.sharedInstance.currentLanguageName != "English" {
            host = "\(host)/zh"
        }
        let url = URL(string: "\(host)/transaction/\(hash)")!
        open(url)
    }
}
