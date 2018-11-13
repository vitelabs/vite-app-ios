//
//  SendViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Vite_HDWalletKit
import BigInt
import PromiseKit
import JSONRPCKit

class SendViewController: BaseViewController {

    // FIXME: Optional
    let bag = HDWalletManager.instance.bag!

    var token: Token
    var balance: Balance

    let address: Address?
    let amount: Balance?
    let note: String?

    let noteCanEdit: Bool

    init(token: Token, address: Address?, amount: BigInt?, note: String?, noteCanEdit: Bool = true) {
        self.token = token
        self.address = address
        self.balance = Balance(value: BigInt(0))
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
        setupView()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kas_activateAutoScrollingForView(scrollView.stackView)
        FetchQuotaService.instance.retainQuota()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FetchQuotaService.instance.releaseQuota()
    }

    // View
    lazy var scrollView = ScrollableView(insets: UIEdgeInsets(top: 10, left: 24, bottom: 30, right: 24)).then {
        $0.layer.masksToBounds = false
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    // headerView
    lazy var headerView = SendHeaderView(address: bag.address.description)

    lazy var amountView = SendAmountView(amount: amount?.amountFull(decimals: token.decimals) ?? "", symbol: token.symbol)
    lazy var noteView = SendNoteView(note: note ?? "", canEdit: noteCanEdit)

    private func setupView() {
        navigationTitleView = NavigationTitleView(title: R.string.localizable.sendPageTitle.key.localized())
        let addressView: SendAddressViewType = address != nil ? AddressLabelView(address: address!.description) : AddressTextViewView()
        let sendButton = UIButton(style: .blue, title: R.string.localizable.sendPageSendButtonTitle.key.localized())

        view.addSubview(scrollView)
        view.addSubview(sendButton)

        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(navigationTitleView!.snp.bottom)
            m.left.right.equalTo(view)
        }

        scrollView.stackView.addArrangedSubview(headerView)
        scrollView.stackView.addPlaceholder(height: 30)
        scrollView.stackView.addArrangedSubview(addressView)
        scrollView.stackView.addArrangedSubview(amountView)
        scrollView.stackView.addArrangedSubview(noteView)

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
        let next: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.sendPageAmountToolbarButtonTitle.key.localized(), style: .done, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.finish.key.localized(), style: .done, target: nil, action: nil)
        if noteCanEdit {
            toolbar.items = [flexSpace, next]
        } else {
            toolbar.items = [flexSpace, done]
        }
        toolbar.sizeToFit()
        next.rx.tap.bind { [weak self] in self?.noteView.textField.becomeFirstResponder() }.disposed(by: rx.disposeBag)
        done.rx.tap.bind { [weak self] in self?.amountView.textField.resignFirstResponder() }.disposed(by: rx.disposeBag)
        amountView.textField.inputAccessoryView = toolbar

        addressView.textView.kas_setReturnAction(.next(responder: amountView.textField))
        amountView.textField.delegate = self
        noteView.textField.kas_setReturnAction(.done(block: {
            $0.resignFirstResponder()
        }), delegate: self)

        sendButton.rx.tap
            .bind { [weak self] in
                let address = Address(string: addressView.textView.text ?? "")
                guard let `self` = self else { return }
                guard address.isValid else {
                    Toast.show(R.string.localizable.sendPageToastAddressError.key.localized())
                    return
                }
                guard let amountString = self.amountView.textField.text,
                    !amountString.isEmpty,
                    let amount = amountString.toBigInt(decimals: self.token.decimals) else {
                    Toast.show(R.string.localizable.sendPageToastAmountEmpty.key.localized())
                    return
                }

                guard amount > BigInt(0) else {
                    Toast.show(R.string.localizable.sendPageToastAmountZero.key.localized())
                    return
                }

                guard amount <= self.balance.value else {
                    Toast.show(R.string.localizable.sendPageToastAmountError.key.localized())
                    return
                }
                self.showConfirmTransactionViewController(address: address, amountString: amountString, amount: amount)
            }
            .disposed(by: rx.disposeBag)
    }

    private func bind() {
        FetchBalanceInfoService.instance.balanceInfosDriver.drive(onNext: { [weak self] balanceInfos in
            guard let `self` = self else { return }
            for balanceInfo in balanceInfos where self.token.id == balanceInfo.token.id {
                self.balance = balanceInfo.balance
                self.headerView.balanceLabel.text = balanceInfo.balance.amountFull(decimals: balanceInfo.token.decimals)
                return
            }

            // no balanceInfo, set 0.0
            self.headerView.balanceLabel.text = "0.0"
        }).disposed(by: rx.disposeBag)
        FetchQuotaService.instance.quotaDriver.drive(headerView.quotaLabel.rx.text).disposed(by: rx.disposeBag)
        FetchQuotaService.instance.maxTxCountDriver.drive(headerView.maxTxCountLabel.rx.text).disposed(by: rx.disposeBag)
    }

    private func showConfirmTransactionViewController(address: Address, amountString: String, amount: BigInt) {

        let biometryAuthConfig = HDWalletManager.instance.isTransferByBiometry
        let confirmType: ConfirmTransactionViewController.ConfirmTransactionType =  biometryAuthConfig ? .biometry : .password
        let confirmViewController = ConfirmTransactionViewController(confirmType: confirmType, address: address.description, token: self.token.symbol, amount: amountString, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.sendTransactionWithoutGetPow(bag: self.bag, toAddress: address, tokenId: self.token.id, amount: amount, note: self.noteView.textField.text)
            case .cancelled:
                plog(level: .info, log: "Confirm cancelled", tag: .transaction)
            case .biometryAuthFailed:
                Alert.show(into: self,
                           title: R.string.localizable.sendPageConfirmBiometryAuthFailedTitle.key.localized(),
                           message: nil,
                           actions: [(.default(title: R.string.localizable.sendPageConfirmBiometryAuthFailedBack.key.localized()), nil)])
            case .passwordAuthFailed:
                Alert.show(into: self,
                           title: R.string.localizable.confirmTransactionPageToastPasswordError.key.localized(),
                           message: nil,
                           actions: [(.default(title: R.string.localizable.sendPageConfirmPasswordAuthFailedRetry.key.localized()), { [unowned self] _ in
                                self.showConfirmTransactionViewController(address: address, amountString: amountString, amount: amount)
                           }), (.cancel, nil)])
            }
        })
        self.present(confirmViewController, animated: false, completion: nil)
    }

    private func sendTransactionWithoutGetPow(bag: HDWalletManager.Bag, toAddress: Address, tokenId: String, amount: BigInt, note: String?) {
        HUD.show()
        Provider.instance.sendTransactionWithoutGetPow(bag: bag, toAddress: toAddress, tokenId: tokenId, amount: amount, data: note?.bytes.toBase64()) { [weak self] result in
            guard let `self` = self else { return }
            HUD.hide()
            switch result {
            case .success:
                Toast.show(R.string.localizable.sendPageToastSendSuccess.key.localized())
                GCD.delay(0.5) { self.dismiss() }
            case .error(let error):
                if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
                    Alert.show(into: self,
                               title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle.key.localized(),
                               message: nil,
                               actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton.key.localized()), nil)])
                } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
                    Alert.show(into: self, title: R.string.localizable.quotaAlertTitle.key.localized(), message: R.string.localizable.quotaAlertPowAndQuotaMessage.key.localized(), actions: [
                        (.default(title: R.string.localizable.quotaAlertPowButtonTitle.key.localized()), { _ in
                            self.sendTransactionWithGetPow(bag: bag, toAddress: toAddress, tokenId: tokenId, amount: amount, note: note)
                        }),
                        (.default(title: R.string.localizable.quotaAlertQuotaButtonTitle.key.localized()), { [weak self] _ in
                            let vc = QuotaManageViewController()
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }),
                        (.cancel, nil),
                        ], config: { alert in
                            alert.preferredAction = alert.actions[1]
                    })
                } else {
                    Toast.show(R.string.localizable.sendPageToastSendFailed.key.localized())
                }
            }
        }
    }

    private func sendTransactionWithGetPow(bag: HDWalletManager.Bag, toAddress: Address, tokenId: String, amount: BigInt, note: String?) {
        var cancelPow = false
        let getPowFloatView = GetPowFloatView(superview: UIApplication.shared.keyWindow!) {
            cancelPow = true
        }

        getPowFloatView.show()
        Provider.instance.sendTransactionWithGetPow(bag: bag, toAddress: toAddress, tokenId: tokenId, amount: amount, data: note?.bytes.toBase64(), difficulty: AccountBlock.Const.Difficulty.sendWithoutData.value, completion: { [weak self] (result) in

            guard cancelPow == false else { return }
            guard let `self` = self else { return }
            switch result {
            case .success(let context):

                getPowFloatView.finish {
                    HUD.show()
                    Provider.instance.sendTransactionWithContext(context, completion: { [weak self] (result) in
                        HUD.hide()
                        guard let `self` = self else { return }
                        switch result {
                        case .success:
                            Toast.show(R.string.localizable.sendPageToastSendSuccess.key.localized())
                            GCD.delay(0.5) { self.dismiss() }
                        case .error(let error):
                            if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
                                Alert.show(into: self,
                                           title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle.key.localized(),
                                           message: nil,
                                           actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton.key.localized()), nil)])
                            } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
                                Alert.show(into: self, title: R.string.localizable.quotaAlertTitle.key.localized(), message: R.string.localizable.quotaAlertNeedQuotaMessage.key.localized(), actions: [
                                    (.default(title: R.string.localizable.quotaAlertQuotaButtonTitle.key.localized()), { [weak self] _ in
                                        let vc = QuotaManageViewController()
                                        self?.navigationController?.pushViewController(vc, animated: true)
                                    }),
                                    (.cancel, nil),
                                    ], config: { alert in
                                        alert.preferredAction = alert.actions[0]
                                })
                            } else {
                                Toast.show(R.string.localizable.sendPageToastSendFailed.key.localized())
                            }
                        }
                    })
                }
            case .error:
                getPowFloatView.hide()
                Toast.show(R.string.localizable.sendPageToastSendFailed.key.localized())
            }
        })
    }
}

extension SendViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountView.textField {
            let (ret, text) = InputLimitsHelper.allowDecimalPointWithDigitalText(textField.text ?? "", shouldChangeCharactersIn: range, replacementString: string, decimals: min(8, token.decimals))
            textField.text = text
            return ret
        } else if textField == noteView.textField {
            return InputLimitsHelper.allowText(textField.text ?? "", shouldChangeCharactersIn: range, replacementString: string, maxCount: 180)
        } else {
            return true
        }
    }
}
