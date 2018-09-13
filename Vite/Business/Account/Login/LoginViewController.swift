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
            make.center.equalTo(self.view)
            make.width.height.equalTo(150)
        }

        self.view.addSubview(self.createAccountBtn)
        self.createAccountBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-150)
            make.centerX.equalTo(self.view)
        }

        self.view.addSubview(self.importAccountBtn)
        self.importAccountBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-80)
            make.centerX.equalTo(self.view)
        }

//        self.view.addSubview(self.changeLanguageBtn)
//        self.changeLanguageBtn.snp.makeConstraints { (make) -> Void in
//            make.width.equalTo(60)
//            make.height.equalTo(50)
//            make.right.equalTo(self.view).offset(-30)
//            make.top.equalTo(self.view).offset(100)
//        }
    }

    @objc func createAccountBtnAction() {
        let vc = CreateWalletAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func importAccountBtnAction() {
        let vc = ImportAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func loginBtnAction() {
        let alertController = UIAlertController.init()
        let cancelAction = UIAlertAction(title: LocalizationStr("Cancel"), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let languages: [Language] = SettingDataService.sharedInstance.getSupportedLanguages()
        for element in languages {
            let action = UIAlertAction(title: element.displayName, style: .destructive, handler: {_ in
                _ = SetLanguage(element.name)
            })
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
