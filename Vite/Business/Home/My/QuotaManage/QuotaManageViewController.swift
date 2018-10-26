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
        kas_activateAutoScrollingForView(contentView)
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
    // money
    lazy var amountView = TitleMoneyInputView(title: R.string.localizable.quotaManagePageQuotaMoneyTitle.key.localized(), placeholder: R.string.localizable.quotaManagePageQuotaMoneyPlaceholder.key.localized(), content: "", desc: TokenCacheService.instance.viteToken.symbol)

    //snapshoot height
    lazy var snapshootHeightLab = TitleDescView(title: R.string.localizable.quotaManagePageQuotaSnapshootHeightTitle.key.localized(), desc: R.string.localizable.quotaManagePageQuotaSnapshootHeightDesc.key.localized())

    private func setupView() {
        navigationTitleView = NavigationTitleView(title: R.string.localizable.quotaManagePageTitle.key.localized())
        let addressView = SendAddressView(address: address?.description ?? "")
        let sendButton = UIButton(style: .blue, title: R.string.localizable.quotaManagePageSubmitBtnTitle.key.localized())
        let checkQuotaListBtn = UIButton(style: .whiteWithoutShadow, title: R.string.localizable.quotaManagePageCheckQuotaListBtnTitle.key.localized())
        checkQuotaListBtn.titleLabel?.font = Fonts.Font14_b

        let shadowView = UIView().then {
            $0.backgroundColor = UIColor.white
            $0.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 20
        }

        view.addSubview(scrollView)
        view.addSubview(sendButton)
        view.addSubview(checkQuotaListBtn)

        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(navigationTitleView!.snp.bottom)
            m.left.right.equalTo(view)
        }

        contentView.addSubview(shadowView)
        contentView.addSubview(headerView)
        contentView.addSubview(addressView)
        contentView.addSubview(amountView)
        contentView.addSubview(snapshootHeightLab)

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
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.top.equalTo(addressView.snp.bottom)
        }

        snapshootHeightLab.snp.makeConstraints { (m) in
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.top.equalTo(amountView.snp.bottom).offset(40)
            m.bottom.equalTo(contentView).offset(-30)
        }

        sendButton.snp.makeConstraints { (m) in
            m.top.greaterThanOrEqualTo(scrollView.snp.bottom).offset(10)
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.height.equalTo(50)
        }

        checkQuotaListBtn.snp.makeConstraints { (m) in
            m.top.equalTo(sendButton.snp.bottom).offset(16)
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.bottom.equalTo(view.safeAreaLayoutGuideSnpBottom).offset(-24)
            m.height.equalTo(20)
        }

        addressView.textView.keyboardType = .default
        amountView.textField.keyboardType = .decimalPad

        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: R.string.localizable.finish.key.localized(), style: .done, target: nil, action: nil)
        toolbar.items = [flexSpace, done]
        toolbar.sizeToFit()
        done.rx.tap.bind { [weak self] in self?.amountView.textField.resignFirstResponder() }.disposed(by: rx.disposeBag)
        amountView.textField.inputAccessoryView = toolbar

        addressView.textView.kas_setReturnAction(.next(responder: amountView.textField))
        amountView.textField.delegate = self

        sendButton.rx.tap
            .bind { [weak self] in
                let address = Address(string: addressView.textView.text ?? "")
                guard let `self` = self else { return }
//                guard address.isValid else {
//                    Toast.show(R.string.localizable.sendPageToastAddressError.key.localized())
//                    return
//                }
                guard let amountString = self.amountView.textField.text,
                    !amountString.isEmpty,
                    let amount = amountString.toBigInt(decimals: TokenCacheService.instance.viteToken.decimals) else {
                        Toast.show(R.string.localizable.sendPageToastAmountEmpty.key.localized())
                        return
                }

                guard amount > BigInt(0) else {
                    Toast.show(R.string.localizable.sendPageToastAmountZero.key.localized())
                    return
                }

//                guard amount <= self.balance.value else {
//                    Toast.show(R.string.localizable.sendPageToastAmountError.key.localized())
//                    return
//                }

                let vc = QuotaSubmitPopViewController(money: String.init(format: "%f %@", amountString, TokenCacheService.instance.viteToken.symbol))
                vc.modalPresentationStyle = .overCurrentContext
                let delegate =  StyleActionSheetTranstionDelegate()
                vc.transitioningDelegate = delegate
                self.present(vc, animated: true, completion: nil)

//               self.pledgeAndGainQuotaWithoutGetPow(beneficialAddress: self.bag.address, amount: BigInt("10000000000000000000"))
            }
            .disposed(by: rx.disposeBag)

        checkQuotaListBtn.rx.tap
            .bind { [weak self] in
                //TODO:::
                let vc = TransactionListViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: rx.disposeBag)
    }
}

//bind
extension QuotaManageViewController {
    func initBinds() {

    }
}

//service
extension QuotaManageViewController {
    //no run pow request service
    func pledgeAndGainQuotaWithoutGetPow(beneficialAddress: Address, amount: BigInt) {
        self.view.displayLoading(text: "")
        Provider.instance.pledgeAndGainQuotaWithoutGetPow(bag: bag, beneficialAddress: beneficialAddress, tokenId: TokenCacheService.instance.viteToken.id, amount: amount) { [weak self] (result) in
            guard let `self` = self else { return }
            self.view.hideLoading()
            switch result {
            case .success:
                Toast.show("success")
                GCD.delay(0.5) { self.dismiss() }
            case .error(let error):
                if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
                    Alert.show(into: self,
                               title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle.key.localized(),
                               message: nil,
                               actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton.key.localized()), nil)])
                } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
                    Alert.show(into: self, title: "没配额", message: nil, actions: [
                        (.default(title: "获取pow"), { _ in
                            self.pledgeAndGainQuotaWithGetPow(beneficialAddress: beneficialAddress, amount: amount)
                        }),
                        (.cancel, nil),
                        ])
                } else {
                    Toast.show(error.message)
                }
            }
        }
    }

    //run pow request service
    func pledgeAndGainQuotaWithGetPow(beneficialAddress: Address, amount: BigInt) {
        self.view.displayLoading(text: "获取pow")
        Provider.instance.pledgeAndGainQuotaWithGetPow(bag: bag, beneficialAddress: beneficialAddress, tokenId: TokenCacheService.instance.viteToken.id, amount: amount, difficulty: AccountBlock.Const.difficulty) { [weak self] (result) in
            guard let `self` = self else { return }
            self.view.hideLoading()
            switch result {
            case .success:
                Toast.show("success")
                GCD.delay(0.5) { self.dismiss() }
            case .error(let error):
                if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
                    Alert.show(into: self,
                               title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle.key.localized(),
                               message: nil,
                               actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton.key.localized()), nil)])
                } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
                    Toast.show("获取pow转账也失败了")
                } else {
                    Toast.show(error.message)
                }
            }
        }
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
}
