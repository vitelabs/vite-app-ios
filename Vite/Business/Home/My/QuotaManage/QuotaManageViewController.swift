//
//  QuotaManageViewController.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import BigInt

class QuotaManageViewController: BaseViewController {
    // FIXME: Optional
    let bag = HDWalletManager.instance.bag!

    var address: Address?
    var balance: Balance

    init() {
        self.balance = Balance(value: BigInt(0))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initBinds()
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
    lazy var scrollView = ScrollableView(insets: UIEdgeInsets(top: 10, left: 24, bottom: 50, right: 24)).then {
        $0.layer.masksToBounds = false
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    // headerView
    lazy var headerView = SendHeaderView(address: bag.address.description)

    // money
    lazy var amountView = TitleMoneyInputView(title: R.string.localizable.quotaManagePageQuotaMoneyTitle(), placeholder: R.string.localizable.quotaManagePageQuotaMoneyPlaceholder(), content: "", desc: TokenCacheService.instance.viteToken.symbol).then {
        $0.textField.keyboardType = .decimalPad
    }

    //snapshoot height
    lazy var snapshootHeightLab = TitleDescView(title: R.string.localizable.quotaManagePageQuotaSnapshootHeightTitle()).then {
        let str = R.string.localizable.quotaManagePageQuotaSnapshootHeightDesc("3")
        let range = str.range(of: "3")!
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor: Colors.titleGray_40], range: NSRange.init(range, in: str))
        $0.descLab.attributedText = attributedString
    }

    lazy var addressView = AddressTextViewView(currentAddress: self.bag.address.description, placeholder: R.string.localizable.quotaSubmitPageQuotaAddressPlaceholder()).then {
        $0.titleLabel.text = R.string.localizable.quotaManagePageInputAddressTitle()
        $0.textView.keyboardType = .default
    }

    lazy var sendButton = UIButton(style: .blue, title: R.string.localizable.quotaManagePageSubmitBtnTitle())

    private func setupNavBar() {
        statisticsPageName = Statistics.Page.WalletQuota.name
        navigationTitleView = createNavigationTitleView()
        let rightItem = UIBarButtonItem(title: R.string.localizable.quotaManagePageCheckQuotaListBtnTitle(), style: .plain, target: self, action: nil)
        rightItem.setTitleTextAttributes([NSAttributedStringKey.font: Fonts.Font14, NSAttributedStringKey.foregroundColor: Colors.blueBg], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedStringKey.font: Fonts.Font14, NSAttributedStringKey.foregroundColor: Colors.blueBg], for: .highlighted)
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem?.rx.tap.bind {[weak self] in
            let pledgeHistoryVC = PledgeHistoryViewController()
            pledgeHistoryVC.reactor = PledgeHistoryViewReactor()
            self?.navigationController?.pushViewController(pledgeHistoryVC, animated: true)
        }.disposed(by: rx.disposeBag)
    }

    private func setupView() {
        setupNavBar()

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(navigationTitleView!.snp.bottom)
            m.left.right.bottom.equalTo(view)
        }

        sendButton.snp.makeConstraints { (m) in
            m.height.equalTo(50)
        }

        scrollView.stackView.addArrangedSubview(headerView)
        scrollView.stackView.addPlaceholder(height: 30)
        scrollView.stackView.addArrangedSubview(addressView)
        scrollView.stackView.addPlaceholder(height: 30)
        scrollView.stackView.addArrangedSubview(amountView)
        scrollView.stackView.addPlaceholder(height: 40)
        scrollView.stackView.addArrangedSubview(snapshootHeightLab)
        scrollView.stackView.addPlaceholder(height: 37)
        scrollView.stackView.addArrangedSubview(sendButton)

        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.finish(), style: .done, target: nil, action: nil)
        toolbar.items = [flexSpace, done]
        toolbar.sizeToFit()
        done.rx.tap.bind { [weak self] in self?.amountView.textField.resignFirstResponder() }.disposed(by: rx.disposeBag)
        amountView.textField.inputAccessoryView = toolbar

        addressView.textView.kas_setReturnAction(.next(responder: amountView.textField), delegate: addressView)
        amountView.textField.delegate = self

        self.initBtnAction()
    }

    func createNavigationTitleView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = UIColor.white
        }

        let titleLabel = LabelTipView(R.string.localizable.quotaManagePageTitle()).then {
            $0.titleLab.font = UIFont.systemFont(ofSize: 24)
            $0.titleLab.numberOfLines = 1
            $0.titleLab.adjustsFontSizeToFitWidth = true
            $0.titleLab.textColor = UIColor(netHex: 0x24272B)
        }

        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(view).offset(6)
            m.left.equalTo(view).offset(24)
            m.bottom.equalTo(view).offset(-20)
            m.height.equalTo(29)
        }

        titleLabel.tipButton.rx.tap.bind { [weak self] in
            let url  = URL(string: String(format: "%@?localize=%@", Constants.quotaDefinitionURL, LocalizationService.sharedInstance.currentLanguage.rawValue))!
            let vc = PopViewController(url: url)
            vc.modalPresentationStyle = .overCurrentContext
            let delegate =  StyleActionSheetTranstionDelegate()
            vc.transitioningDelegate = delegate
            self?.present(vc, animated: true, completion: nil)
        }.disposed(by: rx.disposeBag)
        return view
    }
}

//bind
extension QuotaManageViewController {

    func initBtnAction() {
        sendButton.rx.tap
            .bind { [weak self] in
                Statistics.log(eventId: Statistics.Page.WalletQuota.submit.rawValue)
                guard let `self` = self else { return }
                let address = Address(string: self.addressView.textView.text ?? "")

                guard address.isValid else {
                    Toast.show(R.string.localizable.sendPageToastAddressError())
                    return
                }

                guard let amountString = self.amountView.textField.text,
                    !amountString.isEmpty,
                    let amount = amountString.toBigInt(decimals: TokenCacheService.instance.viteToken.decimals) else {
                        Toast.show(R.string.localizable.sendPageToastAmountEmpty())
                        return
                }

                guard amount > BigInt(0) else {
                    Toast.show(R.string.localizable.sendPageToastAmountZero())
                    return
                }

                guard amount <= self.balance.value else {
                    Toast.show(R.string.localizable.sendPageToastAmountError())
                    return
                }

                guard amount >= "10".toBigInt(decimals: TokenCacheService.instance.viteToken.decimals)! else {
                    Toast.show(R.string.localizable.quotaManagePageToastMoneyError())
                    return
                }

                let vc = QuotaSubmitPopViewController(money: amountString, beneficialAddress: address, amount: amount)
                vc.delegate = self
                vc.modalPresentationStyle = .overCurrentContext
                let delegate =  StyleActionSheetTranstionDelegate()
                vc.transitioningDelegate = delegate
                self.present(vc, animated: true, completion: nil)

            }
            .disposed(by: rx.disposeBag)
    }

    func refreshDataBySuccess() {
        self.addressView.textView.text = ""
        self.amountView.textField.text = ""
    }

    func initBinds() {
        FetchBalanceInfoService.instance.balanceInfosDriver.drive(onNext: { [weak self] balanceInfos in
            guard let `self` = self else { return }
            for balanceInfo in balanceInfos where TokenCacheService.instance.viteToken.id == balanceInfo.token.id {
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
}

//service
extension QuotaManageViewController {
    //no run pow request service
    //auto run pledgeAndGainQuotaWithGetPow with error
    func pledgeAndGainQuotaWithoutGetPow(beneficialAddress: Address, amount: BigInt) {
        HUD.show()
        Provider.instance.pledgeAndGainQuotaWithoutGetPow(bag: bag, beneficialAddress: beneficialAddress, tokenId: TokenCacheService.instance.viteToken.id, amount: amount) { [weak self] (result) in
            guard let `self` = self else { return }
            HUD.hide()
            switch result {
            case .success:
                self.refreshDataBySuccess()
                Toast.show(R.string.localizable.submitSuccess())
            case .failure(let error):
                if error.code == ViteErrorCode.rpcNotEnoughBalance {
                    Alert.show(into: self,
                               title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle(),
                               message: nil,
                               actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton()), nil)])
                } else if error.code == ViteErrorCode.rpcNotEnoughQuota {
                    self.pledgeAndGainQuotaWithGetPow(beneficialAddress: beneficialAddress, amount: amount)
                } else {
                    Toast.show(error.message)
                }
            }
        }
    }

    //run pow request service
    func pledgeAndGainQuotaWithGetPow(beneficialAddress: Address, amount: BigInt) {
        var cancelPow = false
        let getPowFloatView = GetPowFloatView(superview: UIApplication.shared.keyWindow!) {
            cancelPow = true
        }

        getPowFloatView.show()
        Provider.instance.pledgeAndGainQuotaWithGetPow(bag: bag, beneficialAddress: beneficialAddress, tokenId: TokenCacheService.instance.viteToken.id, amount: amount, difficulty: AccountBlock.Const.Difficulty.pledge.value) { [weak self] (result) in

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
                              self.refreshDataBySuccess()
                              Toast.show(R.string.localizable.submitSuccess())
                        case .failure(let error):
                            if error.code == ViteErrorCode.rpcNotEnoughBalance {
                                Alert.show(into: self,
                                           title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle(),
                                           message: nil,
                                           actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton()), nil)])
                            } else {
                                Toast.show(error.message)
                            }
                        }
                    })
                }
            case .failure(let error):
                getPowFloatView.hide()
                Toast.show(error.message)
            }
        }
    }
}

extension QuotaManageViewController: QuotaSubmitPopViewControllerDelegate {
    func confirmAction(beneficialAddress: Address, amountString: String, amount: BigInt) {
        Statistics.log(eventId: Statistics.Page.WalletQuota.confirm.rawValue)
        self.showConfirmTransactionViewController(beneficialAddress: beneficialAddress, amountString: amountString, amount: amount)
    }
}

extension QuotaManageViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountView.textField {
            let (ret, text) = InputLimitsHelper.allowDecimalPointWithDigitalText(textField.text ?? "", shouldChangeCharactersIn: range, replacementString: string, decimals: min(8, TokenCacheService.instance.viteToken.decimals))
            textField.text = text
            return ret
        } else {
            return true
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == amountView.textField {
            amountView.symbolLabel.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountView.textField {
            amountView.symbolLabel.isHidden = textField.text?.isEmpty ?? true
        }
    }
}

extension QuotaManageViewController {
    private func showConfirmTransactionViewController(beneficialAddress: Address, amountString: String, amount: BigInt) {
        let biometryAuthConfig = HDWalletManager.instance.isTransferByBiometry
        let confirmType: ConfirmTransactionViewController.ConfirmTransactionType =  biometryAuthConfig ? .biometry : .password
        let confirmViewController = ConfirmTransactionViewController(confirmType: confirmType, address: beneficialAddress.description, token: TokenCacheService.instance.viteToken.symbol, amount: amountString, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.pledgeAndGainQuotaWithoutGetPow(beneficialAddress: beneficialAddress, amount: amount)
            case .cancelled:
                plog(level: .info, log: "Confirm cancelled", tag: .transaction)
            case .biometryAuthFailed:
                Alert.show(into: self,
                           title: R.string.localizable.sendPageConfirmBiometryAuthFailedTitle(),
                           message: nil,
                           actions: [(.default(title: R.string.localizable.sendPageConfirmBiometryAuthFailedBack()), nil)])
            case .passwordAuthFailed:
                Alert.show(into: self,
                           title: R.string.localizable.confirmTransactionPageToastPasswordError(),
                           message: nil,
                           actions: [(.default(title: R.string.localizable.sendPageConfirmPasswordAuthFailedRetry()), { [unowned self] _ in self.showConfirmTransactionViewController(beneficialAddress: beneficialAddress, amountString: amountString, amount: amount)
                           }), (.cancel, nil)])
            }
        })
        confirmViewController.confirmView.transactionInfoView.titleLabel.text = R.string.localizable.quotaManagePageInputAddressTitle()
        self.present(confirmViewController, animated: false, completion: nil)
    }
}
