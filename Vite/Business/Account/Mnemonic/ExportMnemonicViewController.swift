//
//  ExportMnemonicViewController.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Vite_HDWalletKit

extension UIViewController {
    func verifyWalletPassword(callback: @escaping () -> Void) {
        let controller = UIAlertController(title: nil, message: R.string.localizable.exportPageAlterTitle.key.localized(), preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel.key.localized(), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: R.string.localizable.confirm.key.localized(), style: UIAlertActionStyle.default) { (_) in
            let textField = (controller.textFields?.first)! as UITextField
            if WalletDataService.shareInstance.verifyWalletPassword(pwd: textField.text!) {
                callback()
            } else {
                self.view.showToast(str: R.string.localizable.exportPageAlterPasswordError.key.localized())
            }
        }
        controller.addTextField { (textfield) in
            textfield.keyboardType = .numberPad
            textfield.isSecureTextEntry = true
            textfield.placeholder = R.string.localizable.exportPageAlterTfPlaceholder.key.localized()
        }
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
}

class ExportMnemonicViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var contentTextView: UITextView = {
        let contentTextView =  UITextView()
        contentTextView.font = Fonts.Font18
        contentTextView.backgroundColor = Colors.bgGray
        contentTextView.textColor = Colors.descGray
        contentTextView.text = WalletDataService.shareInstance.defaultWalletAccount?.mnemonic
        contentTextView.layer.masksToBounds = true
        contentTextView.layer.cornerRadius = 2
        contentTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        return contentTextView
    }()

    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton.init(style: .blue)
        confirmBtn.setTitle(R.string.localizable.confirm.key.localized(), for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return confirmBtn
    }()
}

extension ExportMnemonicViewController {

    private func _setupView() {
        self.view.backgroundColor = .white
        navigationTitleView = NavigationTitleView(title: R.string.localizable.exportPageTitle.key.localized())

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

        self.view.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }
    }

    @objc func confirmBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
