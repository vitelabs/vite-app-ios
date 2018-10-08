//
//  LoginViewController.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Vite_HDWalletKit
import Toast_Swift
import ActionSheetPicker_3_0

class LoginViewController: BaseViewController {
    fileprivate var viewModel: LoginViewModel

    init() {
        self.viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kas_activateAutoScrollingForView(contentView)
    }

    let contentView = UIView()

    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.backgroundColor = .clear
        logoImgView.image =  R.image.login_logo()
        return logoImgView
    }()

    lazy var userNameBtn: TitleBtnView = {
        let userNameBtn = TitleBtnView(title: R.string.localizable.loginPageBtnChooseName.key.localized(), text: self.viewModel.chooseWalletAccount.name)
        userNameBtn.btn.addTarget(self, action: #selector(userNameBtnAction), for: .touchUpInside)
        return userNameBtn
    }()

    lazy var walletNameTF: TitleTextFieldView = {
        let walletNameTF = TitleTextFieldView(title: R.string.localizable.createPageTfTitle.key.localized(), placeholder: "", text: "")
        walletNameTF.titleLabel.textColor = Colors.titleGray
        walletNameTF.textField.font = AppStyle.inputDescWord.font
        walletNameTF.textField.textColor = Colors.descGray
        walletNameTF.titleLabel.font = AppStyle.formHeader.font
        return walletNameTF
    }()

    lazy var passwordTF: TitlePasswordInputView = {
        let passwordTF = TitlePasswordInputView.init(title: R.string.localizable.createPagePwTitle.key.localized())
        passwordTF.titleLabel.textColor = Colors.titleGray
        passwordTF.titleLabel.font = AppStyle.formHeader.font
        return passwordTF
    }()

    lazy var createAccountBtn: UIButton = {
        let createAccountBtn = UIButton.init(style: .whiteWithoutShadow)
        createAccountBtn.setTitle(R.string.localizable.createAccount.key.localized(), for: .normal)
        createAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        createAccountBtn.addTarget(self, action: #selector(createAccountBtnAction), for: .touchUpInside)
        return createAccountBtn
    }()

    lazy var importAccountBtn: UIButton = {
        let importAccountBtn = UIButton.init(style: .whiteWithoutShadow)
        importAccountBtn.setTitle(R.string.localizable.importAccount.key.localized(), for: .normal)
        importAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        importAccountBtn.addTarget(self, action: #selector(importAccountBtnAction), for: .touchUpInside)
        return importAccountBtn
    }()

    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton.init(style: .blue)
        loginBtn.setTitle(R.string.localizable.loginPageBtnLogin.key.localized(), for: .normal)
        loginBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        loginBtn.addTarget(self, action: #selector(loginBtnAction), for: .touchUpInside)
        return loginBtn
    }()
}

extension LoginViewController {
    private func _setupView() {
        self.view.backgroundColor = .white
        navigationBarStyle = .clear
        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (m) in
            m.edges.equalTo(view)
        }
        contentView.addSubview(self.logoImgView)
        self.logoImgView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.safeAreaLayoutGuideSnpTop).offset(80)
            make.width.height.equalTo(84)
        }

        contentView.addSubview(self.userNameBtn)
        self.userNameBtn.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.height.equalTo(60)
        }

        contentView.addSubview(self.passwordTF)
        self.passwordTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.userNameBtn.snp.bottom).offset(40)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.height.equalTo(62)
        }

        contentView.addSubview(self.loginBtn)
        self.loginBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.safeAreaLayoutGuideSnpBottom).offset(-80)
        }

        contentView.addSubview(self.createAccountBtn)
        self.createAccountBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.safeAreaLayoutGuideSnpBottom).offset(-24)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView.snp.centerX).offset(-2)
        }

        let line = UIView()
        line.backgroundColor = Colors.lineGray
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(16)
            make.width.equalTo(1)
            make.centerY.equalTo(self.createAccountBtn)
            make.centerX.equalTo(contentView)
        }

        contentView.addSubview(self.importAccountBtn)
        self.importAccountBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.safeAreaLayoutGuideSnpBottom).offset(-24)
            make.right.equalTo(contentView).offset(-24)
            make.left.equalTo(contentView.snp.centerX).offset(2)
        }
    }

    @objc func createAccountBtnAction() {
        let vc = CreateWalletAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func importAccountBtnAction() {
        let vc = ImportAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func userNameBtnAction() {
        let pickData = self.viewModel.walletStorage.walletAccounts.map { (account) -> String in
             return account.name
        }

        _ =  ActionSheetStringPicker.show(withTitle: "选择钱包账户", rows: pickData, initialSelection: 0, doneBlock: {_, index, _ in
            self.viewModel.chooseWalletAccount = self.viewModel.walletStorage.walletAccounts[index]
            self.userNameBtn.btn.setTitle(self.viewModel.chooseWalletAccount.name, for: .normal)
            return
        }, cancel: { _ in return }, origin: self.view)

    }

    @objc func loginBtnAction() {
        let password = self.passwordTF.passwordInputView.textField.text

        if self.viewModel.chooseWalletAccount.password == password?.pwdEncrypt() {
                self.view.displayLoading(text: R.string.localizable.loginPageLoadingTitle.key.localized(), animated: true)
                DispatchQueue.global().async {
                    WalletDataService.shareInstance.loginWallet(account: self.viewModel.chooseWalletAccount)
                    DispatchQueue.main.async {
                        self.view.hideLoading()
                        NotificationCenter.default.post(name: .createAccountSuccess, object: nil)
                    }
                }
        } else {
            self.displayConfirmAlter(title: R.string.localizable.loginPageErrorToastTitle.key.localized(), done: R.string.localizable.confirm.key.localized(), doneHandler: {
            })
        }
    }
}
