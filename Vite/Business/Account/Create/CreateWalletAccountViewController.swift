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
import Vite_HDWalletKit

extension CreateWalletAccountViewController {
    private func _bindViewModel() {
        self.createNameAndPwdVM = CreateNameAndPwdVM(input: (self.createNameAndPwdView.walletNameTF.textField, self.createNameAndPwdView.passwordTF.passwordInputView.textField, self.createNameAndPwdView.passwordRepeateTF.passwordInputView.textField))
        self.createNameAndPwdVM?.submitBtnEnable.drive(onNext: { (isEnabled) in
                self.submitBtn.isEnabled = isEnabled
            }).disposed(by: rx.disposeBag)

        self.submitBtn.rx.tap.bind {_ in
            self.createNameAndPwdVM?.submitAction.execute((self.createNameAndPwdView.walletNameTF.textField.text ?? "", self.createNameAndPwdView.passwordTF.passwordInputView.textField.text ?? "", self.createNameAndPwdView.passwordRepeateTF.passwordInputView.textField.text ?? "")).subscribe(onNext: { (result) in
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
    fileprivate var createNameAndPwdVM: CreateNameAndPwdVM?

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

    let contentView = UIView()

    lazy var createNameAndPwdView: CreateNameAndPwdView = {
        let createNameAndPwdView = CreateNameAndPwdView()
        return createNameAndPwdView
    }()

    lazy var submitBtn: UIButton = {
        var submitBtn = UIButton.init(style: .blue)
    submitBtn.setTitle(R.string.localizable.createPageSubmitBtnTitle.key.localized(), for: .normal)
        submitBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        submitBtn.setBackgroundImage(UIImage.color(Colors.btnDisableGray), for: .disabled)
        return submitBtn
    }()
}

extension CreateWalletAccountViewController {

    private func _setupView() {
        self.view.backgroundColor = .white
        navigationTitleView = NavigationTitleView(title: R.string.localizable.createPageTitle.key.localized())

        self._addViewConstraint()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kas_activateAutoScrollingForView(contentView)
    }

    private func _addViewConstraint() {
        view.insertSubview(contentView, at: 0)
        contentView.snp.makeConstraints { (m) in
            m.edges.equalTo(view)
        }
        contentView.addSubview(self.createNameAndPwdView)
        self.createNameAndPwdView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.top.equalTo(contentView).offset(60)
        }

        contentView.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.safeAreaLayoutGuideSnpBottom).offset(-24)
        }
    }

    func goNextVC() {
        CreateWalletService.sharedInstance.walletAccount.name = self.createNameAndPwdView.walletNameTF.textField.text!.trimmingCharacters(in: .whitespaces)
        CreateWalletService.sharedInstance.walletAccount.password = self.createNameAndPwdView.passwordRepeateTF.passwordInputView.textField.text!.pwdEncrypt()
        let vc = CreateWalletTipViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
