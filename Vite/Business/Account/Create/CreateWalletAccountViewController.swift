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

extension CreateWalletAccountViewController {
    private func _bindViewModel() {
        let viewModel = CreateWalletAccountVM(input: (self.walletNameTF, self.passwordTF.textField, self.passwordRepeateTF.textField))

        viewModel.accountNameEnable.drive(onNext: { (result) in
            switch result {
            case .ok:
                break
            case .empty:
                self.walletNameLab.text = result.description
            case .failed:
                self.walletNameLab.text = result.description
            }
        }).disposed(by: rx.disposeBag)

        viewModel.inputRepeatePwdEnable.drive(onNext: { (result) in
            switch result {
            case .ok:
                break
            case .failed:
                self.passwordLab.text = result.description
            case .empty:
                self.passwordLab.text = result.description
            }
        }).disposed(by: rx.disposeBag)

        viewModel.submitBtnEnable.drive(onNext: { (isEnabled) in
            self.submitBtn.isEnabled = isEnabled
        }).disposed(by: rx.disposeBag)

        //边框处理
//        viewModel.accountNameEnable.drive(self.walletNameTF.rx.validationResult).disposed(by: rx.disposeBag)
//        viewModel.inputPwdEnable.drive(self.passwordTF.textField.rx.validationResult).disposed(by: rx.disposeBag)
    }
}

class CreateWalletAccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
        self._bindViewModel()
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
        submitBtn.setBackgroundImage(UIImage.color(.red), for: .normal)
        submitBtn.setBackgroundImage(UIImage.color(.gray), for: .disabled)
        submitBtn.setBackgroundImage(UIImage.color(.red), for: .highlighted)
        submitBtn.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        return submitBtn
    }()

    lazy var dismissKeyboardBtn: UIButton = {
        let dismissKeyboardBtn = UIButton()
        dismissKeyboardBtn.backgroundColor = .clear
        dismissKeyboardBtn.addTarget(self, action: #selector(dismissKeyboardBtnAction), for: .touchUpInside)
        return dismissKeyboardBtn
    }()
}

extension CreateWalletAccountViewController: PasswordInputViewDelegate {
    func inputFinish(passwordView: PasswordInputView, password: String) {
//        if passwordView.tag == 101 {
//            self.viewModel.inputPwdStr = password
//        } else {
//            self.viewModel.repeatInputPwdStr = password
//        }
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
        self.view.addSubview(dismissKeyboardBtn)
        dismissKeyboardBtn.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        self.view.addSubview(walletNameTF)
        walletNameTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }

        self.view.addSubview(walletNameLab)
        self.walletNameLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(walletNameTF.snp.bottom).offset(10)
            make.left.equalTo(walletNameTF)
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

    @objc func dismissKeyboardBtnAction() {
        self.walletNameTF.resignFirstResponder()
        _ = self.passwordTF.resignFirstResponder()
        _ = self.passwordRepeateTF.resignFirstResponder()
    }

    @objc func submitBtnAction() {
        let vc = CreateWalletTipViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
