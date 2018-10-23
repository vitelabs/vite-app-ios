//
//  Route.swift
//  Vite
//
//  Created by Water on 2018/10/23.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import UIKit

struct Route {
    static func getTopVC() -> (UIViewController?) {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for  windowTemp in windows {
                if windowTemp.windowLevel == UIWindowLevelNormal {
                    window = windowTemp
                    break
                }
            }
        }

        let vc = window?.rootViewController
        return getTopVC(withCurrentVC: vc)
    }

    ///根据控制器获取 顶层控制器
    static func getTopVC(withCurrentVC VC: UIViewController?) -> UIViewController? {

        if VC == nil {
            print("🌶： can't find root vc")
            return nil
        }

        if let presentVC = VC?.presentedViewController {
            //modal
            return getTopVC(withCurrentVC: presentVC)
        } else if let tabVC = VC as? UITabBarController {
            // tabBar
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            //nav
            return getTopVC(withCurrentVC: naiVC.visibleViewController)
        } else {
            // result
            return VC
        }
    }
}
