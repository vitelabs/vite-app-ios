//
//  SendViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Vite_keystore
import BigInt
import PromiseKit

class SendViewController: BaseViewController {

    let bag = HDWalletManager.instance.bag()

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

        // test
        addressView.textField.text = "vite_4827fbc6827797ac4d9e814affb34b4c5fa85d39bf96d105e7" // iphone x
        addressView.textField.text = "vite_18068b64b49852e1c4dfbc304c4e606011e068836260bc9975" // iphone 6s
        //        addressView.textField.text = "vite_568c182884e989ea87995412051cb40f1cdf5a6896d658f434" // iphone se 10.3.1

        let tokenId = Token.Currency.vite.rawValue
//        let amount = BigInt(1000000000000000000)
        let amount = BigInt(1234567890123456789)

        sendButton.rx.tap.bind { [weak self] in
            let confirmViewController = ConfirmTransactionViewController(confirmTypye: .biometry, address: addressView.textField.text!, token: "vcc", amount: "10000", completion: { [weak self] (result) in
                guard let `self` = self else { return }
                if result {
                    self.sendTransaction(bag: self.bag, toAddress: Address(string: addressView.textField.text!), tokenId: tokenId, amount: amount)
                }
            })
            self?.present(confirmViewController, animated: false, completion: nil)
        }.disposed(by: rx.disposeBag)

    }

    func sendTransaction(bag: HDWalletManager.Bag, toAddress: Address, tokenId: String, amount: BigInt) {

        let transactionProvider = TransactionProvider(server: RPCServer.shared)
        _ = transactionProvider.getLatestAccountBlock(address: bag.address)
            .then({ [weak self] (latestAccountBlock, snapshotChainHash) -> Promise<Void> in
                let send = AccountBlock.makeSendAccountBlock(latest: latestAccountBlock,
                                                             bag: self!.bag,
                                                             snapshotChainHash: snapshotChainHash,
                                                             toAddress: toAddress,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: nil)
                return transactionProvider.createTransaction(accountBlock: send)
            })
            .done({
                print("🏆")
            })
            .catch({ (error) in
                print("🤯🤯🤯🤯🤯🤯\(error)")
            })
            .finally({

            })
    }
}
