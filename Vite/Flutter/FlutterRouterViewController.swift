//
//  FlutterRouterViewController.swift
//  MyApp
//
//  Created by Water on 2019/8/5.
//  Copyright © 2019 vite labs. All rights reserved.
//
import UIKit
import ViteBusiness

protocol FlutterRouterPort {
    var name: String { get }
    var params: [String: Any] { get }
}

enum FlutterPage: FlutterRouterPort {
    case discoverHome
    case marketHome
    case gatewayInfo(String)
    case tokenInfo(String)

    var name: String {
        switch self {
        case .discoverHome:
            return "viteWallet://discoverHome"
        case .marketHome:
            return "viteWallet://marketHome"
        case .gatewayInfo(_):
            return "viteWallet://gatewayInfo"
        case .tokenInfo(_):
            return "viteWallet://tokenInfo"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .discoverHome:
            return [:]
        case .marketHome:
            return [:]
        case .gatewayInfo(let gateway):
            return [
                    "gateway": gateway,
                    ]
        case .tokenInfo(let tokenCode):
            return [
                "tokenCode": tokenCode]
        }
    }    
}

class FlutterRouterViewController: FLBFlutterViewContainer {
    convenience init(name: String, params: [String: Any]) {
        self.init()
        self.setName(name, params: params)
    }
    /// push
    func becomingPush(root: UIViewController?, animated: Bool) {
        FlutterRouter.shared.navigation = root?.navigationController
        FlutterRouter.shared.open(self.name(), urlParams: self.params(), exts: [:]) { (_) in

        }
        root?.navigationController?.pushViewController(self, animated: animated)
    }

    /// present
    func becomingPresent(root: UIViewController?, animated: Bool, completion: (() -> Void)?) {
        FlutterRouter.shared.open(self.name(), urlParams: self.params(), exts: [:]) { (_) in

        }
        root?.present(self, animated: animated, completion: completion)
    }
    
    /// presentNavigation
    func becomingPresentNavigation(root: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let navigation = UINavigationController(rootViewController: self)
        FlutterRouter.shared.navigation = navigation
        becomingPresent(root: navigation, animated: animated, completion: completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true ,animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension FlutterRouterViewController {
    
    convenience init(page: FlutterPage, title: String?) {
        self.init(name: page.name, params: page.params)
        self.title = title
    }
}
