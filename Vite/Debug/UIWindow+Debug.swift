//
//  UIWindow+Debug.swift
//  Vite
//
//  Created by Stone on 2018/10/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

#if DEBUG

import UIKit

extension UIWindow {

    open override var canBecomeFocused: Bool {
        return true
    }

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        showDebugVC()
    }

    func showDebugVC() {
        let vc = DebugViewController()
        let nav = BaseNavigationController(rootViewController: vc)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let rootVC = appDelegate.window?.rootViewController else { return }

        nav.modalPresentationStyle = .formSheet
        var top = rootVC

        while let presentedViewController = top.presentedViewController {
            top = presentedViewController
        }

        if let n = top as? UINavigationController, n.viewControllers.first is DebugViewController {
            return
        }

        top.present(nav, animated: true, completion: nil)
    }
}

#endif
