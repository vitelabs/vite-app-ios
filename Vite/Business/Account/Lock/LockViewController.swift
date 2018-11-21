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
import Vite_HDWalletKit
import LocalAuthentication

class LockViewController: BaseViewController {
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
        let btnDescView = BtnDescView.init(title: R.string.localizable.lockPageFingerprintBtnTitle())
        btnDescView.btn.setImage(R.image.fingerprint(), for: .normal)
        btnDescView.btn.setImage(R.image.fingerprint(), for: .highlighted)
        btnDescView.btn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return btnDescView
    }()

    lazy var loginPwdBtn: UIButton = {
        let loginBtn = UIButton.init(style: .whiteWithoutShadow)
        loginBtn.setTitle(R.string.localizable.lockPagePwdBtnTitle(), for: .normal)
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
        }
    }

    @objc func loginBtnAction() {
        let vc = LockPwdViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func confirmBtnAction() {
        self.showBiometricAuth()
    }
}

extension LockViewController {
    private func showBiometricAuth() {
        self.touchValidation()
    }
    private func touchValidation() {
        BiometryAuthenticationManager.shared.authenticate(reason: R.string.localizable.lockPageFingerprintAlterTitle(), completion: { (success, _) in
            guard success else { return }

            self.view.displayLoading(text: R.string.localizable.loginPageLoadingTitle(), animated: true)

            DispatchQueue.global().async {
                if let wallet = KeychainService.instance.currentWallet,
                    wallet.uuid == HDWalletManager.instance.wallet?.uuid,
                    HDWalletManager.instance.loginCurrent(encryptKey: wallet.encryptKey) {
                    DispatchQueue.main.async {
                        self.view.hideLoading()
                        NotificationCenter.default.post(name: .unlockDidSuccess, object: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.hideLoading()
                        Toast.show(R.string.localizable.toastErrorLogin())
                    }
                }
            }
        })
    }
}
