//
//  ImportAccountViewController.swift
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

extension ImportAccountViewController {
    private func _bindViewModel() {
        self.importAccountVM = ImportAccountVM.init(input: (self.contentTextView, self.createNameAndPwdView.walletNameTF.textField, self.createNameAndPwdView.passwordTF.passwordInputView.textField, self.createNameAndPwdView.passwordRepeateTF.passwordInputView.textField))

        self.importAccountVM?.submitBtnEnable.drive(onNext: { (isEnabled) in
                self.confirmBtn.isEnabled = isEnabled
        }).disposed(by: rx.disposeBag)

        self.confirmBtn.rx.tap.bind {_ in
            self.importAccountVM?.submitAction.execute((self.contentTextView.text, self.createNameAndPwdView.walletNameTF.textField.text ?? "", self.createNameAndPwdView.passwordTF.passwordInputView.textField.text ?? "", self.createNameAndPwdView.passwordRepeateTF.passwordInputView.textField.text ?? "")).subscribe(onNext: { (result) in
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

class ImportAccountViewController: BaseViewController {
    fileprivate var importAccountVM: ImportAccountVM?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
        self._bindViewModel()
    }

    lazy var contentTextView: UITextView = {
        let contentTextView =  UITextView()
        contentTextView.font = Fonts.Font18
        contentTextView.backgroundColor = Colors.bgGray
        contentTextView.textColor = Colors.descGray
        contentTextView.text = ""
        contentTextView.layer.masksToBounds = true
        contentTextView.layer.cornerRadius = 2
        contentTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentTextView.isEditable = true
        contentTextView.isScrollEnabled = true
        return contentTextView
    }()

    lazy var createNameAndPwdView: CreateNameAndPwdView = {
        let createNameAndPwdView = CreateNameAndPwdView()
        return createNameAndPwdView
    }()

    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton.init(style: .blue)
        confirmBtn.setTitle(R.string.localizable.importPageSubmitBtn.key.localized(), for: .normal)
        confirmBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        confirmBtn.setBackgroundImage(UIImage.color(Colors.btnDisableGray), for: .disabled)
        return confirmBtn
    }()

}

extension ImportAccountViewController {

    private func _setupView() {
        kas_activateAutoScrollingForView(view)
        self.view.backgroundColor = .white
        navigationTitleView = NavigationTitleView(title: R.string.localizable.importPageTitle.key.localized())

        self._addViewConstraint()
    }
    private func _addViewConstraint() {
        self.view.addSubview(self.contentTextView)
        self.contentTextView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(142)
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!).offset(10)
        }

        self.view.addSubview(self.createNameAndPwdView)
        self.createNameAndPwdView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(self.contentTextView.snp.bottom).offset(20)
        }

        self.view.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }
    }

    func goNextVC() {
        let wallet = WalletAccount()
        wallet.name  = self.createNameAndPwdView.walletNameTF.textField.text!.trimmingCharacters(in: .whitespaces)
        wallet.password = self.createNameAndPwdView.passwordRepeateTF.passwordInputView.textField.text!.pwdEncrypt()
        wallet.mnemonic = self.contentTextView.text
        self.view.displayLoading(text: R.string.localizable.mnemonicAffirmPageAddLoading.key.localized(), animated: true)
        DispatchQueue.global().async {

            WalletDataService.shareInstance.updateWallet(account: wallet)
            WalletDataService.shareInstance.loginWallet(account: wallet)
            DispatchQueue.main.async {
                self.view.hideLoading()
                NotificationCenter.default.post(name: .createAccountSuccess, object: nil)
            }
        }
    }
}
