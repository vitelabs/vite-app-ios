//
//  LockViewController.swift
//  Vite
//
//  Created by Water on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Vite_keystore
import LocalAuthentication

class LockViewController: BaseViewController {
    private var context: LAContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupView()

        self.showBiometricAuth()
    }

    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.backgroundColor = .clear
        logoImgView.image =  R.image.login_logo()
        return logoImgView
    }()

    lazy var btnDescView: BtnDescView = {
        let btnDescView = BtnDescView.init(title: R.string.localizable.lockPageFingerprintBtnTitle.key.localized())
        btnDescView.btn.setImage(R.image.fingerprint(), for: .normal)
        return btnDescView
    }()

    lazy var loginPwdBtn: UIButton = {
        let loginBtn = UIButton.init(style: .whiteWithoutShadow)
        loginBtn.setTitle(R.string.localizable.lockPagePwdBtnTitle.key.localized(), for: .normal)
        loginBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        loginBtn.addTarget(self, action: #selector(loginBtnAction), for: .touchUpInside)
        return loginBtn
    }()
}

extension LockViewController {
    private func _setupView() {
        self.view.backgroundColor = .white
        navigationBarStyle = .clear
        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        self.view.addSubview(self.logoImgView)
        self.logoImgView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuideSnpTop).offset(10)
            make.width.height.equalTo(84)
        }

        self.view.addSubview(self.btnDescView)
        self.btnDescView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.height.equalTo(110)
            make.width.equalTo(100)
        }

        self.view.addSubview(self.loginPwdBtn)
        self.loginPwdBtn.snp.makeConstraints { (make) -> Void in
            make.centerX.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-40)
            make.height.equalTo(30)
        }
    }

    @objc func loginBtnAction() {
        let vc = LockPwdViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LockViewController {
    private func showBiometricAuth() {
        self.context = LAContext()
        self.touchValidation()
    }

    private func canEvaluatePolicy() -> Bool {
        var authError: NSError?
        let result = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        if result == false {
            self.view.showToast(str: authError?.localizedDescription ?? "")
        }
        return result
    }
    private func touchValidation() {
        guard canEvaluatePolicy() else {

            //
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "open switch") { [weak self] success, _ in
            DispatchQueue.main.async {
                if success {
                        NotificationCenter.default.post(name: .unlockDidSuccess, object: nil)
                } else {

                }
            }
        }
    }
}
