//
//  UIView+Loading.swift
//  Vite
//
//  Created by Water on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Toast_Swift
import MBProgressHUD

extension UIView {

    func displayLoading(
        text: String = R.string.localizable.loading.key.localized(),
        animated: Bool = true
        ) {
        let hud = MBProgressHUD.showAdded(to: self, animated: animated)
        hud.label.text = text
    }

    func hideLoading(animated: Bool = true) {
        MBProgressHUD.hide(for: self, animated: animated)
    }

    func  showToast (str: String) {
        self.makeToast(str, duration: 2.0, position: .center)
    }
}
