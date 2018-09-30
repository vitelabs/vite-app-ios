//
//  LockPwdViewController.swift
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

class LockPwdViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kas_activateAutoScrollingForView(view)
    }

    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.backgroundColor = .clear
        logoImgView.image =  R.image.login_logo()
        return logoImgView
    }()

    lazy var passwordTF: TitlePasswordInputView = {
        let passwordTF = TitlePasswordInputView.init(title: R.string.localizable.createPagePwTitle.key.localized())
        passwordTF.titleLabel.textColor = Colors.titleGray
        passwordTF.titleLabel.font = AppStyle.formHeader.font
        passwordTF.passwordInputView.delegate = self
        return passwordTF
    }()

    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton.init(style: .blue)
        loginBtn.setTitle(R.string.localizable.loginPageBtnLogin.key.localized(), for: .normal)
        loginBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        loginBtn.addTarget(self, action: #selector(loginBtnAction), for: .touchUpInside)
        return loginBtn
    }()
}

extension LockPwdViewController {
    private func _setupView() {
        self.view.backgroundColor = .white
        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        self.view.addSubview(self.logoImgView)
        self.logoImgView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuideSnpTop).offset(50)
            make.width.height.equalTo(84)
        }

        self.view.addSubview(self.passwordTF)
        self.passwordTF.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.view)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(62)
        }

        self.view.addSubview(self.loginBtn)
        self.loginBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }
    }

    @objc func loginBtnAction() {
        let password = self.passwordTF.passwordInputView.textField.text

        if WalletDataService.shareInstance.defaultWalletAccount?.password == password?.pwdEncrypt() {
            self.view.displayLoading(text: R.string.localizable.loginPageLoadingTitle.key.localized(), animated: true)
            DispatchQueue.global().async {
                WalletDataService.shareInstance.loginWallet(account: WalletDataService.shareInstance.defaultWalletAccount ?? WalletAccount())
                DispatchQueue.main.async {
                    self.view.hideLoading()
                    NotificationCenter.default.post(name: .unlockDidSuccess, object: nil)
                }
            }
        } else {
            self.displayConfirmAlter(title: R.string.localizable.loginPageErrorToastTitle.key.localized(), done: R.string.localizable.confirm.key.localized(), doneHandler: {
            })
        }
    }
}

extension LockPwdViewController: PasswordInputViewDelegate {
    func inputFinish(passwordView: PasswordInputView, password: String) {
        if passwordView ==  self.passwordTF.passwordInputView {
            _ = self.passwordTF.passwordInputView.resignFirstResponder()
            self.loginBtnAction()
        }
    }
}
