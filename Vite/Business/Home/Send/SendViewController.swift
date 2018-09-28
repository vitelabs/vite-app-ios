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
import JSONRPCKit

class SendViewController: BaseViewController, ViewControllerDataStatusable {

    let bag = HDWalletManager.instance.bag()

    var token: Token! = nil
    var balance: Balance! = nil

    let tokenId: String
    let address: Address?
    let amount: Balance?
    let note: String?

    let noteCanEdit: Bool

    init(tokenId: String, address: Address?, amount: BigInt?, note: String?, noteCanEdit: Bool = true) {
        self.tokenId = tokenId
        self.address = address
        if let amount = amount {
            self.amount = Balance(value: amount)
        } else {
            self.amount = nil
        }
        self.note = note
        self.noteCanEdit = noteCanEdit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let token = TokenCacheService.instance.tokenForId(tokenId) {
            self.token = token
            setupView()
            bind()
        } else {
            getToken()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kas_activateAutoScrollingForView(contentView)
    }

    private func getToken() {
        self.dataStatus = .loading
        Provider.instance.getTokenForId(tokenId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let token):
                TokenCacheService.instance.updateTokensIfNeeded([token])
                self.token = token
                self.dataStatus = .normal
                self.setupView()
                self.bind()
            case .error(let error):
                self.dataStatus = .networkError(error, { [weak self] in
                    self?.dataStatus = .loading
                    self?.getToken()
                })
            }
        }
    }

    // View
    lazy var scrollView = ScrollableView().then {
        $0.layer.masksToBounds = false
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    lazy var contentView = UIView().then { view in
        view.layer.masksToBounds = false
        scrollView.addSubview(view)
        view.snp.makeConstraints { (m) in
            m.edges.equalTo(scrollView)
            m.width.equalTo(scrollView)
        }
    }

    // headerView
    lazy var headerView = SendHeaderView(address: bag.address.description)

    lazy var amountView = SendAmountView(amount: amount?.amountFull(decimals: token.decimals) ?? "", symbol: token.symbol)
    lazy var noteView = SendNoteView(note: note ?? "", canEdit: noteCanEdit)

    private func setupView() {

        navigationTitleView = NavigationTitleView(title: R.string.localizable.sendPageTitle())

        let addressView = SendAddressView(address: address?.description ?? "")
        let sendButton = UIButton(style: .blue, title: R.string.localizable.sendPageSendButtonTitle())

        let shadowView = UIView().then {
            $0.backgroundColor = UIColor.white
            $0.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 20
        }

        view.addSubview(scrollView)
        view.addSubview(sendButton)

        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(navigationTitleView!.snp.bottom)
            m.left.right.equalTo(view)
        }

        contentView.addSubview(shadowView)
        contentView.addSubview(headerView)
        contentView.addSubview(addressView)
        contentView.addSubview(amountView)
        contentView.addSubview(noteView)

        shadowView.snp.makeConstraints { (m) in
            m.edges.equalTo(headerView)
        }

        headerView.snp.makeConstraints { (m) in
            m.top.equalTo(contentView)
            m.left.equalTo(contentView).offset(24)
            m.right.equalTo(contentView).offset(-24)
        }

        addressView.snp.makeConstraints { (m) in
            m.left.right.equalTo(contentView)
            m.top.equalTo(headerView.snp.bottom).offset(30)
        }

        amountView.snp.makeConstraints { (m) in
            m.left.right.equalTo(contentView)
            m.top.equalTo(addressView.snp.bottom)
        }

        noteView.snp.makeConstraints { (m) in
            m.left.right.equalTo(contentView)
            m.top.equalTo(amountView.snp.bottom)
            m.bottom.equalTo(contentView).offset(-30)
        }

        sendButton.snp.makeConstraints { (m) in
            m.top.greaterThanOrEqualTo(scrollView.snp.bottom).offset(10)
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.bottom.equalTo(view.safeAreaLayoutGuideSnpBottom).offset(-24)
            m.height.equalTo(50)
        }

        addressView.textView.keyboardType = .default
        amountView.textField.keyboardType = .decimalPad
        noteView.textField.keyboardType = .default

        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.sendPageAmountToolbarButtonTitle(), style: .done, target: nil, action: nil)
        toolbar.items = [flexSpace, done]
        toolbar.sizeToFit()
        done.rx.tap.bind { [weak self] in self?.noteView.textField.becomeFirstResponder() }.disposed(by: rx.disposeBag)
        amountView.textField.inputAccessoryView = toolbar

        addressView.textView.kas_setReturnAction(.next(responder: amountView.textField))
        amountView.textField.kas_setReturnAction(.next(responder: noteView.textField), delegate: self)
        noteView.textField.kas_setReturnAction(.done(block: {
            $0.resignFirstResponder()
        }), delegate: self)

        sendButton.rx.tap
            .bind { [weak self] in
                guard let `self` = self else { return }
                guard Address.isValid(string: addressView.textView.text ?? "") else {
                    Toast.show(R.string.localizable.sendPageToastAddressError())
                    return
                }
                guard let amountString = self.amountView.textField.text, let amount = amountString.toBigInt(decimals: self.token.decimals) else { return }
                guard amount <= self.balance.value else {
                    Toast.show(R.string.localizable.sendPageToastAmountError())
                    return
                }

                let address = Address(string: addressView.textView.text!)
                let biometryAuthConfig = WalletDataService.shareInstance.defaultWalletAccount?.isSwitchTransfer ?? false
                let confirmType: ConfirmTransactionViewController.ConfirmTransactionType =  biometryAuthConfig ? .biometry : .password

                let confirmViewController = ConfirmTransactionViewController(confirmType: confirmType, address: address.description, token: self.token.symbol, amount: amountString, completion: { [weak self] (result) in
                    guard let `self` = self else { return }
                    switch result {
                    case .success:
                        self.sendTransaction(bag: self.bag, toAddress: address, tokenId: self.tokenId, amount: amount, note: self.noteView.textField.text)
                    case .cancelled:
                        print("cancelled")
                    case .biometryAuthFailed:
                        Alert.show(into: self,
                                   title: R.string.localizable.sendPageConfirmBiometryAuthFailedTitle(),
                                   message: nil,
                                   actions: [(.default(title: R.string.localizable.sendPageConfirmBiometryAuthFailedBack()), nil)])
                    case .passwordAuthFailed:
                        Alert.show(into: self,
                                   title: R.string.localizable.confirmTransactionPageToastPasswordError(),
                                   message: nil,
                                   actions: [(.default(title: R.string.localizable.sendPageConfirmPasswordAuthFailedRetry()), { [unowned sendButton] _ in sendButton.sendActions(for: .touchUpInside) }), (.cancel, nil)])
                    }
                })
                self.present(confirmViewController, animated: false, completion: nil)
            }
            .disposed(by: rx.disposeBag)
    }

    private func bind() {
        FetchBalanceInfoService.instance.balanceInfosDriver.drive(onNext: { [weak self] balanceInfos in
            guard let `self` = self else { return }
            for balanceInfo in balanceInfos where self.token.id == balanceInfo.token.id {
                self.balance = balanceInfo.balance
                self.headerView.balanceLabel.text = balanceInfo.balance.amountFull(decimals: balanceInfo.token.decimals)
            }
        }).disposed(by: rx.disposeBag)
    }

    private func sendTransaction(bag: HDWalletManager.Bag, toAddress: Address, tokenId: String, amount: BigInt, note: String?) {

        Provider.instance.sendTransaction(bag: bag, toAddress: toAddress, tokenId: tokenId, amount: amount, note: note) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                Toast.show(R.string.localizable.sendPageToastSendSuccess())
                GCD.delay(0.5) { self.dismiss() }
            case .error(let error):
                if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
                    Alert.show(into: self,
                               title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle(),
                               message: nil,
                               actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton()), nil)])
                } else {
                    Toast.show(error.message)
                }
            }
        }
    }
}

extension SendViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountView.textField {
            let (ret, text) = InputLimitsHelper.allowDecimalPointWithDigitalText(textField.text ?? "", shouldChangeCharactersIn: range, replacementString: string, decimals: 8)
            textField.text = text
            return ret
        } else if textField == noteView.textField {
            return InputLimitsHelper.allowText(textField.text ?? "", shouldChangeCharactersIn: range, replacementString: string, maxCount: 180)
        } else {
            return true
        }
    }
}
