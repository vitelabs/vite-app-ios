//
//  SendViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class SendViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {

        navigationItem.title = R.string.localizable.sendPageTitle()

        kas_activateAutoScrollingForView(view)

        let addressView = TitleTextFieldView(title: R.string.localizable.sendPageToAddressTitle(), placeholder: "", text: "")
        let amountView = TitleTextFieldView(title: R.string.localizable.sendPageAmountTitle(), placeholder: "", text: "")
        let remarkView = TitleTextFieldView(title: R.string.localizable.sendPageRemarkTitle(), placeholder: "", text: "")
        let sendButton = PrimaryButton(title: R.string.localizable.sendPageSendButtonTitle())

        view.addSubview(addressView)
        view.addSubview(amountView)
        view.addSubview(remarkView)
        view.addSubview(sendButton)

        addressView.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuideSnp.top).offset(300)
            m.left.equalTo(view).offset(15)
            m.right.equalTo(view).offset(-15)
        }

        amountView.snp.makeConstraints { (m) in
            m.top.equalTo(addressView.snp.bottom).offset(30)
            m.left.right.equalTo(addressView)
        }

        remarkView.snp.makeConstraints { (m) in
            m.top.equalTo(amountView.snp.bottom).offset(30)
            m.left.right.equalTo(amountView)
        }

        sendButton.snp.makeConstraints { (m) in
            m.left.right.equalTo(remarkView)
            m.bottom.equalTo(view.safeAreaLayoutGuideSnp.bottom).offset(-30)
        }

        addressView.textField.keyboardType = .default
        amountView.textField.keyboardType = .decimalPad
        remarkView.textField.keyboardType = .default

        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.sendPageAmountToolbarButtonTitle(), style: .done, target: nil, action: nil)
        toolbar.items = [flexSpace, done]
        toolbar.sizeToFit()
        done.rx.tap.bind { remarkView.textField.becomeFirstResponder() }.disposed(by: rx.disposeBag)
        amountView.textField.inputAccessoryView = toolbar

        addressView.textField.kas_setReturnAction(.next(responder: amountView.textField))
        amountView.textField.kas_setReturnAction(.next(responder: remarkView.textField))
        remarkView.textField.kas_setReturnAction(.done(block: {
            $0.resignFirstResponder()
        }))

        sendButton.rx.tap.bind { [weak self] in
            let confirmViewController = ConfirmTransactionViewController.init(confirmTypye: .biometry,
                                                                              address: "0xBdEAa223649c580C947058d9b2555269E806C1e7&123456789",
                                                                              token: "vcc",
                                                                              amount: "10000",
                                                                              completion: { (result) in
                                                                                print(result)
            })
           self?.present(confirmViewController, animated: false, completion: nil)
        }.disposed(by: rx.disposeBag)
    }
}
