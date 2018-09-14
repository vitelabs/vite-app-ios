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
import Vite_keystore
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
        self._bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func _bindViewModel() {

    }

    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.backgroundColor = .clear
        logoImgView.image =  R.image.launch_screen_logo()
        return logoImgView
    }()

    lazy var userNameBtn: UIButton = {
        let userNameBtn = UIButton()
        userNameBtn.setTitle(self.viewModel.chooseWalletAccount.name, for: .normal)
        userNameBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        userNameBtn.setTitleColor(.black, for: .normal)
        userNameBtn.backgroundColor = .red
        userNameBtn.addTarget(self, action: #selector(userNameBtnAction), for: .touchUpInside)
        return userNameBtn
    }()

    lazy var passwordLab: UILabel = {
        let passwordLab = UILabel()
        passwordLab.backgroundColor = .clear
        passwordLab.font =  AppStyle.descWord.font
        passwordLab.textColor  = AppStyle.descWord.textColor
        passwordLab.text =    R.string.localizable.createPagePwTitle.key.localized()
        return passwordLab
    }()

    lazy var passwordTF: PasswordInputView = {
        let passwordTF = PasswordInputView()
        return passwordTF
    }()

    lazy var createAccountBtn: UIButton = {
        let createAccountBtn = UIButton()
        createAccountBtn.setTitle(R.string.localizable.createAccount.key.localized(), for: .normal)
        createAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        createAccountBtn.setTitleColor(.black, for: .normal)
        createAccountBtn.backgroundColor = .orange
        createAccountBtn.addTarget(self, action: #selector(createAccountBtnAction), for: .touchUpInside)
        return createAccountBtn
    }()

    lazy var importAccountBtn: UIButton = {
        let importAccountBtn = UIButton()
        importAccountBtn.setTitle(R.string.localizable.importAccount.key.localized(), for: .normal)
        importAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        importAccountBtn.setTitleColor(.black, for: .normal)
        importAccountBtn.backgroundColor = .orange
        importAccountBtn.addTarget(self, action: #selector(importAccountBtnAction), for: .touchUpInside)
        return importAccountBtn
    }()

    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.backgroundColor = .orange
        loginBtn.addTarget(self, action: #selector(loginBtnAction), for: .touchUpInside)
        return loginBtn
    }()
}

extension LoginViewController {
    private func _setupView() {
        self.view.backgroundColor = .white

        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        self.view.addSubview(self.logoImgView)
        self.logoImgView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-200)
            make.width.height.equalTo(150)
        }

        self.view.addSubview(self.userNameBtn)
        self.userNameBtn.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(200)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }

        self.view.addSubview(self.passwordLab)
        self.passwordLab.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.userNameBtn.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        self.view.addSubview(self.passwordTF)
        self.passwordTF.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.passwordLab.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(100)
        }

        self.view.addSubview(self.loginBtn)
        self.loginBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-160)
            make.centerX.equalTo(self.view)
        }

        self.view.addSubview(self.createAccountBtn)
        self.createAccountBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(self.view).offset(-120)
            make.centerX.equalTo(self.view)
        }

        self.view.addSubview(self.importAccountBtn)
        self.importAccountBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(self.view).offset(-50)
            make.centerX.equalTo(self.view)
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

        _ =  ActionSheetStringPicker.show(withTitle: "选择钱包账户", rows: pickData, initialSelection: 1, doneBlock: {
            _, index, _ in
            self.viewModel.chooseWalletAccount = self.viewModel.walletStorage.walletAccounts[index]
            self.userNameBtn.setTitle(self.viewModel.chooseWalletAccount.name, for: .normal)
            return
        }, cancel: { _ in return }, origin: self.view)

    }

    @objc func loginBtnAction() {
        let password = self.passwordTF.textField.text

        if self.viewModel.chooseWalletAccount.password == password {
                WalletDataService.shareInstance.loginWallet(account: self.viewModel.chooseWalletAccount)
                self.view.makeToast("登录成功")
                NotificationCenter.default.post(name: .createAccountSuccess, object: nil)
        } else {
                self.view.makeToast("密码错误，知道助记词可以导入")
        }
    }
}
