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

    func displayRetry(retry: @escaping () -> Swift.Void) {
        let btn = UIButton()
        btn.backgroundColor = .clear
 btn.setTitle(R.string.localizable.sendPageConfirmPasswordAuthFailedRetry.key.localized(), for: .normal)
        btn.setTitleColor(Colors.titleGray, for: .normal)
        self.addSubview(btn)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        btn.center = self.center

        btn.rx.tap.bind {_ in
            retry()
            btn.removeFromSuperview()
        }.disposed(by: rx.disposeBag)
    }

    func  showToast (str: String) {
        self.makeToast(str, duration: 2.0, position: .center)
    }

    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView {
    func  setupShadow (_ shadowOffset: CGSize) {
        self.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = 9
        self.clipsToBounds = false
    }
}

struct Toast {
    static func show(_ string: String, duration: TimeInterval = 2.0, position: ToastPosition = .center) {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.makeToast(string, duration: duration, position: position)
    }
}

struct HUD {
    static func show(_ string: String? = nil) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.label.text = string
    }

    static func hide() {
        guard let window = UIApplication.shared.keyWindow else { return }
        MBProgressHUD.hide(for: window, animated: true)
    }
}
