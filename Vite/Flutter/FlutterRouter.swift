//
//  FlutterRouter.swift
//  MyApp
//
//  Created by Water on 2019/8/5.
//  Copyright © 2019 vite labs. All rights reserved.
//

import Foundation
import Flutter

import ViteBusiness

class FlutterRouter: NSObject {
    static let shared = FlutterRouter()
    var navigation: UINavigationController?
    var flutterViewController: FlutterViewController {
        return FlutterBoostPlugin.sharedInstance()?.currentViewController() ?? FlutterViewController()
    }
    
    override init() {
        super.init()
    }
}

extension FlutterRouter: FLBPlatform {
    func open(_ url: String, urlParams: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        if url == "viteWallet://webPage" {
            let urlParams = urlParams["url"]
            let webVC = WKWebViewController.init(url: URL.init(string: urlParams as! String)!)
            let topVC = Route.getTopVC()
            if let nav = topVC?.navigationController {
                nav.pushViewController(webVC, animated: true)
            } else {
                topVC?.present(webVC, animated: true, completion: nil)
            }
        }
    }
    
    func close(_ uid: String, result: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        UIViewController.current?.navigationController?.popViewController(animated: true)
    }
}
