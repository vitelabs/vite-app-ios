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
        logoImgView.image =  R.image.lock_page_user()
        return logoImgView
    }()

    lazy var userNameLab: UILabel = {
        let userNameLab = UILabel()
        userNameLab.backgroundColor = .clear
        userNameLab.textAlignment = .center
        userNameLab.textColor = Colors.titleGray
        userNameLab.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        userNameLab.text = HDWalletManager.instance.wallet?.name
        return userNameLab
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
        let changeUserBtn = UIButton.init(style: .whiteWithoutShadow)
        changeUserBtn.setTitle(R.string.localizable.lockPageChangeUserBtnTitle.key.localized(), for: .normal)
        changeUserBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        changeUserBtn.addTarget(self, action: #selector(changeUserBtnAction), for: .touchUpInside)
        return changeUserBtn
    }()

    lazy var importUserBtn: UIButton = {
        let importUserBtn = UIButton.init(style: .whiteWithoutShadow)
        importUserBtn.setTitle(R.string.localizable.importPageSubmitBtn.key.localized(), for: .normal)
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
        self.view.addSubview(self.userNameLab)
        self.userNameLab.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(37)
            make.height.equalTo(30)
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
        make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-80)
        }

        self.view.addSubview(self.importUserBtn)
        self.importUserBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuideSnpBottom).offset(-24)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view.snp.centerX).offset(-2)
        }

        self.view.addSubview(self.changeUserBtn)
        self.changeUserBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuideSnpBottom).offset(-24)
            make.right.equalTo(view).offset(-24)
            make.left.equalTo(view.snp.centerX).offset(2)
        }

        let line = UIView()
        line.backgroundColor = Colors.lineGray
        view.addSubview(line)
        line.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(16)
            make.width.equalTo(1)
            make.centerY.equalTo(self.importUserBtn)
            make.centerX.equalTo(view)
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
            if let wallet = HDWalletManager.instance.wallet,
                HDWalletManager.instance.loginCurrent(encryptKey: password.toEncryptKey(salt: wallet.uuid)) {
                KeychainService.instance.setCurrentWallet(uuid: wallet.uuid, encryptKey: password.toEncryptKey(salt: wallet.uuid))
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
        }
    }
}
