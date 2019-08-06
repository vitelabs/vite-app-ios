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
        FlutterBoostPlugin.sharedInstance()?.startFlutter(with: self, onStart: { (_) in
            
        })
    }
}

extension FlutterRouter: FLBPlatform {
    func openPage(_ name: String, params: [AnyHashable: Any], animated: Bool, completion: @escaping (Bool) -> Void) {
        if (name == "viteWallet://webPage") {
            let url = params["url"]

            //

            let webVC = WKWebViewController.init(url: URL.init(string: url as! String)!)
            let topVC = Route.getTopVC()
            if let nav = topVC?.navigationController {
                nav.pushViewController(webVC, animated: true)
            } else {
                topVC?.present(webVC, animated: true, completion: nil)
            }
        }

    }
    func closePage(_ uid: String, animated: Bool, params: [AnyHashable: Any], completion: @escaping (Bool) -> Void) {
    }
}
