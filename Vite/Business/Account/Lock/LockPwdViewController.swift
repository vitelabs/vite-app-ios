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

    lazy var changeUserBtn: UIButton = {
        let changeUserBtn = UIButton.init(style: .blue)
        changeUserBtn.setTitle("切换账户", for: .normal)
        changeUserBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        changeUserBtn.addTarget(self, action: #selector(changeUserBtnAction), for: .touchUpInside)
        return changeUserBtn
    }()

    lazy var importUserBtn: UIButton = {
        let importUserBtn = UIButton.init(style: .blue)
        importUserBtn.setTitle("助记词恢复账户", for: .normal)
        importUserBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        importUserBtn.addTarget(self, action: #selector(importUserBtnAction), for: .touchUpInside)
        return importUserBtn
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

        self.view.addSubview(self.changeUserBtn)
        self.changeUserBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.top.equalTo(self.view.safeAreaLayoutGuideSnpTop).offset(30)
        }

        self.view.addSubview(self.importUserBtn)
        self.importUserBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.view).offset(-24)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.top.equalTo(self.view.safeAreaLayoutGuideSnpTop).offset(30)
        }
    }

    @objc func importUserBtnAction() {
        let vc = ImportAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func changeUserBtnAction() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func loginBtnAction() {

        self.view.displayLoading(text: R.string.localizable.loginPageLoadingTitle.key.localized(), animated: true)
        let password = self.passwordTF.passwordInputView.textField.text ?? ""
        DispatchQueue.global().async {
            if let wallet = KeychainService.instance.currentWallet,
                wallet.uuid == HDWalletManager.instance.wallet?.uuid,
                wallet.encryptKey == password.toEncryptKey(salt: wallet.uuid),
                HDWalletManager.instance.loginCurrent(encryptKey: wallet.encryptKey) {
                DispatchQueue.main.async {
                    self.view.hideLoading()
                    NotificationCenter.default.post(name: .unlockDidSuccess, object: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.view.hideLoading()
                    self.displayConfirmAlter(title: R.string.localizable.loginPageErrorToastTitle.key.localized(), done: R.string.localizable.confirm.key.localized(), doneHandler: {
                    })
                }
            }
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
