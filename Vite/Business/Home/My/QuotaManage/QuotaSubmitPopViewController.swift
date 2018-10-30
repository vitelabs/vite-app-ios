//
//  QuotaSubmitPopViewController.swift
//  Vite
//
//  Created by Water on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import BigInt

protocol  QuotaSubmitPopViewControllerDelegate: class {
    func confirmAction(beneficialAddress: Address, amountString: String, amount: BigInt)
}

class QuotaSubmitPopViewController: BaseViewController {
    let money: String
    let beneficialAddress: Address
    let amount: BigInt
    weak var delegate: QuotaSubmitPopViewControllerDelegate?

    init(money: String, beneficialAddress: Address, amount: BigInt) {
        self.money = money
        self.beneficialAddress = beneficialAddress
        self.amount = amount
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

    lazy var cardBgView = CardBgView(title: R.string.localizable.quotaManagePageSubmitBtnTitle.key.localized())
    lazy var descLab = UILabel().then {
        $0.textColor = Colors.cellTitleGray
        $0.font = Fonts.Font14_b
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = R.string.localizable.quotaSubmitPopDesc.key.localized(arguments: String.init(format: "%@ %@ ", self.money, TokenCacheService.instance.viteToken.symbol))
    }

    lazy var submitBtn = UIButton(style: .blue, title: R.string.localizable.quotaSubmitPopSubmitBtnTitle.key.localized())
    lazy var cancelBtn = UIButton(style: .white, title: R.string.localizable.quotaSubmitPopCancelBtnTitle.key.localized())

    func setupView() {
        self.navigationController?.view.backgroundColor = .clear
        self.view.backgroundColor = .clear

        cardBgView.closeBtn.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: rx.disposeBag)

        view.addSubview(cardBgView)
        cardBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuideSnpBottom).offset(-279)
        }
        cardBgView.addSubview(descLab)
        cardBgView.addSubview(submitBtn)
        cardBgView.addSubview(cancelBtn)

        descLab.snp.makeConstraints { (make) in
            make.left.equalTo(cardBgView).offset(24)
            make.right.equalTo(cardBgView).offset(-24)
            make.top.equalTo(cardBgView).offset(71)
            make.height.equalTo(40)
        }

        submitBtn.snp.makeConstraints { (m) in
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.top.equalTo(descLab.snp.bottom).offset(24)
            m.height.equalTo(50)
        }

        cancelBtn.snp.makeConstraints { (m) in
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.top.equalTo(submitBtn.snp.bottom).offset(20)
            m.height.equalTo(50)
        }
    }

    func initBinds() {
        self.cancelBtn.rx.tap
            .bind { [weak self] in
                self?.dismiss()
            }.disposed(by: rx.disposeBag)

        self.submitBtn.rx.tap
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.confirmAction(beneficialAddress: self.beneficialAddress, amountString: self.money, amount: self.amount)
                self.dismiss()
            }.disposed(by: rx.disposeBag)
    }
}
