//
//  CreateNameAndPwdView.swift
//  Vite
//
//  Created by Water on 2018/9/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class CreateNameAndPwdView: UIView {
    lazy var walletNameTF: TitleTextFieldView = {
        let walletNameTF = TitleTextFieldView(title: R.string.localizable.createPageTfTitle(), placeholder: "", text: "")
        walletNameTF.titleLabel.textColor = Colors.titleGray
        walletNameTF.textField.font = AppStyle.inputDescWord.font
        walletNameTF.textField.textColor = Colors.descGray
        walletNameTF.titleLabel.font = AppStyle.formHeader.font
        return walletNameTF
    }()

    lazy var passwordTF: TitlePasswordInputView = {
        let passwordTF = TitlePasswordInputView.init(title: R.string.localizable.createPagePwTitle())
        passwordTF.passwordInputView.delegate = self
        passwordTF.titleLabel.textColor = Colors.titleGray
        passwordTF.titleLabel.font = AppStyle.formHeader.font
        return passwordTF
    }()

    lazy var passwordRepeateTF: TitlePasswordInputView = {
        let passwordRepeateTF = TitlePasswordInputView.init(title: R.string.localizable.createPagePwRepeateTitle())
        passwordRepeateTF.passwordInputView.delegate = self
        passwordRepeateTF.titleLabel.textColor = Colors.titleGray
        passwordRepeateTF.titleLabel.font = AppStyle.formHeader.font
        return passwordRepeateTF
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        self._addViewConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _addViewConstraint() {
        self.addSubview(walletNameTF)
        walletNameTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(60)
        }

        self.addSubview(self.passwordTF)
        self.passwordTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.walletNameTF.snp.bottom).offset(30)
            make.left.right.equalTo(self)
            make.height.equalTo(60)
        }

        self.addSubview(self.passwordRepeateTF)
        self.passwordRepeateTF.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.passwordTF.snp.bottom).offset(30)
            make.left.right.equalTo(self)
            make.height.equalTo(60)
            make.bottom.equalTo(self)
        }
    }
}

extension CreateNameAndPwdView: PasswordInputViewDelegate {
    func inputFinish(passwordView: PasswordInputView, password: String) {
        if passwordView ==  self.passwordTF.passwordInputView {
            _ = self.passwordTF.passwordInputView.resignFirstResponder()
            _ = self.passwordRepeateTF.passwordInputView.becomeFirstResponder()
        }
        if passwordView ==  self.passwordRepeateTF.passwordInputView {
            _ = self.passwordTF.passwordInputView.resignFirstResponder()
            _ = self.passwordRepeateTF.passwordInputView.resignFirstResponder()
        }
    }
}
