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
        let controller = AlertControl(title: R.string.localizable.exportPageAlterTitle(), message: nil)
        let cancelAction = AlertAction(title: R.string.localizable.cancel(), style: .light, handler: nil)
        let okAction = AlertAction(title: R.string.localizable.confirm(), style: .light) { controller in
            let textField = (controller.textFields?.first)! as UITextField
            if HDWalletManager.instance.verifyPassword(textField.text ?? "") {
                callback()
            } else {
                self.view.showToast(str: R.string.localizable.exportPageAlterPasswordError())
            }
        }
        controller.addTextField { (textfield) in
            textfield.keyboardType = .numberPad
            textfield.isSecureTextEntry = true
            textfield.placeholder = R.string.localizable.exportPageAlterTfPlaceholder()
        }
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        controller.show()
    }
}

class ExportMnemonicViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var contentTextView: MnemonicTextView = {
        let contentTextView =  MnemonicTextView(isEditable: false)
        contentTextView.contentTextView.text = HDWalletManager.instance.mnemonic ?? ""
        return contentTextView
    }()

    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton.init(style: .blue)
        confirmBtn.setTitle(R.string.localizable.confirm(), for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return confirmBtn
    }()
}

extension ExportMnemonicViewController {

    private func _setupView() {
        self.view.backgroundColor = .white
        navigationTitleView = NavigationTitleView(title: R.string.localizable.exportPageTitle())

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
