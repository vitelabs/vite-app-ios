//
//  CreateWalletAccountViewController.swift
//  Vite
//
//  Created by Water on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import NSObject_Rx

class CreateWalletAccountViewController: UIViewController {

    fileprivate var viewModel: LoginHomeVM

    init() {
        self.viewModel = LoginHomeVM.init()
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

    private func _bindViewModel() {

    }

    lazy var walletNameTF: UITextField = {
        let walletNameTF = UITextField()
        walletNameTF.backgroundColor = .gray
        walletNameTF.font =  AppStyle.inputDescWord.font
        walletNameTF.textColor =  AppStyle.descWord.textColor
        return walletNameTF
    }()

    lazy var walletNameLab: UILabel = {
        let walletNameLab = UILabel()
        walletNameLab.backgroundColor = .clear
        walletNameLab.font =  AppStyle.descWord.font
        walletNameLab.textColor  = AppStyle.descWord.textColor
        walletNameLab.text =  R.string.localizable.createPageTfTitle.key.localized()
        return walletNameLab
    }()

    lazy var passwordTF: PasswordInputView = {
        let passwordTF = PasswordInputView()
        passwordTF.delegate = self
        return passwordTF
    }()

    lazy var passwordLab: UILabel = {
        let passwordLab = UILabel()
        passwordLab.backgroundColor = .clear
        passwordLab.font =  AppStyle.descWord.font
        passwordLab.textColor  = AppStyle.descWord.textColor
        passwordLab.text =    R.string.localizable.createPagePwTitle.key.localized()
        return passwordLab
    }()

    lazy var passwordRepeateTF: PasswordInputView = {
        let passwordRepeateTF = PasswordInputView()
        passwordRepeateTF.delegate = self
        return passwordRepeateTF
    }()

    lazy var passwordRepeateLab: UILabel = {
        let passwordRepeateLab = UILabel()
        passwordRepeateLab.backgroundColor = .clear
        passwordRepeateLab.font =  AppStyle.descWord.font
        passwordRepeateLab.textColor  = AppStyle.descWord.textColor
        passwordRepeateLab.text =    R.string.localizable.createPagePwRepeateTitle.key.localized()
        return passwordRepeateLab
    }()

    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton()
        submitBtn.setTitle(R.string.localizable.createPageSubmitBtnTitle.key.localized(), for: .normal)
        submitBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        submitBtn.setTitleColor(.black, for: .normal)
        submitBtn.backgroundColor = .orange
        submitBtn.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        return submitBtn
    }()
}
extension CreateWalletAccountViewController: PasswordInputViewDelegate {
    func accomplished(passwordView: PasswordInputView, password: String) {

    }

    func close(passwordView: PasswordInputView) -> Bool {
        return true
    }
}

extension CreateWalletAccountViewController {
    private func _setupView() {
        self.view.backgroundColor = .white
        self.title = "create.page.title".localized()
        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        self.view.addSubview(self.walletNameTF)
        self.walletNameTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }

        self.view.addSubview(self.walletNameLab)
        self.walletNameLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.walletNameTF.snp.bottom).offset(10)
            make.left.equalTo(self.walletNameTF)
            make.height.equalTo(30)
        }

        self.view.addSubview(self.passwordTF)
        self.passwordTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.walletNameLab.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }

        self.view.addSubview(self.passwordLab)
        self.passwordLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.passwordTF.snp.bottom).offset(10)
            make.left.equalTo(self.passwordTF)
            make.height.equalTo(30)
        }

        self.view.addSubview(self.passwordRepeateTF)
        self.passwordRepeateTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.passwordLab.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }

        self.view.addSubview(self.passwordRepeateLab)
        self.passwordRepeateLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.passwordRepeateTF.snp.bottom).offset(10)
            make.left.equalTo(self.passwordRepeateTF)
            make.height.equalTo(30)
        }

        self.view.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(45)
            make.bottom.equalTo(self.view).offset(-30)
            make.centerX.equalTo(self.view)
        }
    }

    @objc func submitBtnAction() {
        let vc = CreateWalletTipViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
