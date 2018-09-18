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
            self.viewModel = CreateWalletAccountVM(input: (self.walletNameTF.textField, self.passwordTF.passwordInputView.textField, self.passwordRepeateTF.passwordInputView.textField))
        self.viewModel?.submitBtnEnable.drive(onNext: { (isEnabled) in
                self.submitBtn.isEnabled = isEnabled
            }).disposed(by: rx.disposeBag)

        self.submitBtn.rx.tap.bind {_ in
            self.viewModel?.submitAction.execute((self.walletNameTF.textField.text ?? "", self.passwordTF.passwordInputView.textField.text ?? "", self.passwordRepeateTF.passwordInputView.textField.text ?? "")).subscribe(onNext: { (result) in
                switch result {
                case .ok:
                        self.goNextVC()
                case .empty, .failed:
                        self.view.showToast(str: result.description)
                }
            }).disposed(by: self.disposeBag)
        }.disposed(by: rx.disposeBag)
    }
}

class CreateWalletAccountViewController: BaseViewController {
    fileprivate var viewModel: CreateWalletAccountVM?
    var disposeBag = DisposeBag()
    init() {
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
        passwordTF.passwordInputView.delegate = self
        passwordTF.titleLabel.textColor = Colors.titleGray
        passwordTF.titleLabel.font = AppStyle.formHeader.font
        return passwordTF
    }()

    lazy var passwordRepeateTF: TitlePasswordInputView = {
        let passwordRepeateTF = TitlePasswordInputView.init(title: R.string.localizable.createPagePwRepeateTitle.key.localized())
        passwordRepeateTF.passwordInputView.delegate = self
        passwordRepeateTF.titleLabel.textColor = Colors.titleGray
        passwordRepeateTF.titleLabel.font = AppStyle.formHeader.font
        return passwordRepeateTF
    }()

    lazy var submitBtn: UIButton = {
        var submitBtn = UIButton.init(style: .blue)
    submitBtn.setTitle(R.string.localizable.createPageSubmitBtnTitle.key.localized(), for: .normal)
        submitBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        submitBtn.setBackgroundImage(UIImage.color(Colors.btnDisableGray), for: .disabled)
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
        if passwordView ==  self.passwordTF.passwordInputView {
            _ = self.passwordTF.passwordInputView.resignFirstResponder()
            _ = self.passwordRepeateTF.passwordInputView.becomeFirstResponder()
        }
    }
}

extension CreateWalletAccountViewController {

    private func _setupView() {
        self.view.backgroundColor = .white
        kas_activateAutoScrollingForView(view)
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

    func goNextVC() {
        CreateWalletService.sharedInstance.walletAccount.name = self.walletNameTF.textField.text!
        CreateWalletService.sharedInstance.walletAccount.password = self.passwordRepeateTF.passwordInputView.textField.text!
        let vc = CreateWalletTipViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
