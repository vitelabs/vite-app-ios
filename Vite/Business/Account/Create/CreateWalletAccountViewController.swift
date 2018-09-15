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
import Vite_keystore

extension CreateWalletAccountViewController {
    private func _bindViewModel() {
        let viewModel = CreateWalletAccountVM(input: (self.walletNameTF.textField, self.passwordTF.passwordInputView.textField, self.passwordRepeateTF.passwordInputView.textField))

        viewModel.accountNameEnable.drive(onNext: { (result) in
            switch result {
            case .ok:
                break
            case .empty:
//                self.walletNameLab.text = result.description
                break
            case .failed:
//                self.walletNameLab.text = result.description
                break
            }
        }).disposed(by: rx.disposeBag)

        viewModel.inputRepeatePwdEnable.drive(onNext: { (result) in
            switch result {
            case .ok:
                break
            case .failed:
                break
//                self.passwordLab.text = result.description
            case .empty:
                break
//                self.passwordLab.text = result.description
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

class CreateWalletAccountViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
        self._bindViewModel()
    }

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

    lazy var passwordRepeateTF: TitlePasswordInputView = {
        let passwordRepeateTF = TitlePasswordInputView.init(title: R.string.localizable.createPagePwRepeateTitle.key.localized())
        passwordRepeateTF.titleLabel.textColor = Colors.titleGray
        passwordRepeateTF.titleLabel.font = AppStyle.formHeader.font
        return passwordRepeateTF
    }()

    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton.init(style: .blue)
        submitBtn.setTitle(R.string.localizable.createPageSubmitBtnTitle.key.localized(), for: .normal)
        submitBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        submitBtn.setTitleColor(.black, for: .normal)
        submitBtn.setBackgroundImage(UIImage.color(.gray), for: .disabled)
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
        kas_activateAutoScrollingForView(self.view)
        navigationTitleView = NavigationTitleView(title: R.string.localizable.createPageTitle.key.localized())

        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        self.view.addSubview(dismissKeyboardBtn)
        dismissKeyboardBtn.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        self.view.addSubview(walletNameTF)
        walletNameTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(60)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(60)
        }

        self.view.addSubview(self.passwordTF)
        self.passwordTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.walletNameTF.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(60)
        }

        self.view.addSubview(self.passwordRepeateTF)
        self.passwordRepeateTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.passwordTF.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(60)
        }

        self.view.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnp.bottom).offset(-24)
        }
    }

    @objc func dismissKeyboardBtnAction() {
        self.walletNameTF.textField.resignFirstResponder()
        _ = self.passwordTF.passwordInputView.textField.resignFirstResponder()
        _ = self.passwordRepeateTF.passwordInputView.textField.resignFirstResponder()
    }

    @objc func submitBtnAction() {
        CreateWalletService.sharedInstance.walletAccount.name = self.walletNameTF.textField.text!
        CreateWalletService.sharedInstance.walletAccount.password = self.passwordRepeateTF.passwordInputView.textField.text!
        let vc = CreateWalletTipViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
