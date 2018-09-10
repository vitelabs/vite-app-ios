//
//  BalanceInfoDetailView.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

class BalanceInfoDetailView: UIView {

    fileprivate let balanceTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    fileprivate let balanceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    fileprivate let unconfirmedTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    fileprivate let unconfirmedLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    fileprivate let unconfirmedCountLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(balanceTitleLabel)
        addSubview(balanceLabel)
        addSubview(unconfirmedTitleLabel)
        addSubview(unconfirmedLabel)
        addSubview(unconfirmedCountLabel)

        balanceTitleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(15)
            m.left.equalTo(self).offset(15)
        }

        balanceLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(15)
            m.right.equalTo(self).offset(-15)
        }

        unconfirmedTitleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(balanceTitleLabel.snp.bottom).offset(10)
            m.left.equalTo(balanceTitleLabel)
        }

        unconfirmedLabel.snp.makeConstraints { (m) in
            m.top.equalTo(balanceLabel.snp.bottom).offset(10)
            m.right.equalTo(self).offset(-15)
        }

        unconfirmedCountLabel.snp.makeConstraints { (m) in
            m.top.equalTo(unconfirmedTitleLabel.snp.bottom).offset(5)
            m.centerX.equalTo(unconfirmedTitleLabel)
            m.bottom.equalTo(self).offset(-15)
        }

        backgroundColor = UIColor.green

        balanceTitleLabel.text = R.string.localizable.balanceInfoDetailBalanceTitle()
        unconfirmedTitleLabel.text = R.string.localizable.balanceInfoDetailUnconfirmedTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModelBehaviorRelay: BehaviorRelay<WalletHomeBalanceInfoViewModelType>) {
        viewModelBehaviorRelay.asObservable().bind { [weak self] in
            self?.balanceLabel.text = $0.balance
            self?.unconfirmedLabel.text = $0.unconfirmed
            self?.unconfirmedCountLabel.text = R.string.localizable.balanceInfoDetailUnconfirmedCountTitle(String($0.unconfirmedCount))
        }.disposed(by: rx.disposeBag)
    }
}
