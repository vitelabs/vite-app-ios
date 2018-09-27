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
import ChameleonFramework

class BalanceInfoDetailView: UIView {

    fileprivate let symbolLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textColor = UIColor.white
    }

    fileprivate let iconImageView = UIImageView()

    fileprivate let balanceTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.white
    }

    fileprivate let balanceLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.textColor = UIColor.white
    }

    fileprivate let unconfirmedTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.white
    }

    fileprivate let unconfirmedLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.textColor = UIColor.white
    }

//    fileprivate let unconfirmedCountLabel = UILabel().then {
//        $0.font = UIFont.systemFont(ofSize: 12)
//        $0.textColor = UIColor.white
//    }

    fileprivate var backgroundColors: [UIColor] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(symbolLabel)
        addSubview(iconImageView)
        addSubview(balanceTitleLabel)
        addSubview(balanceLabel)
        addSubview(unconfirmedTitleLabel)
        addSubview(unconfirmedLabel)
//        addSubview(unconfirmedCountLabel)

        symbolLabel.snp.makeConstraints { (m) in
            m.left.equalTo(self).offset(24)
        }

        iconImageView.snp.makeConstraints { (m) in
            m.top.equalTo(symbolLabel)
            m.left.equalTo(symbolLabel.snp.right).offset(-10)
            m.right.equalTo(self).offset(-24)
            m.size.equalTo(CGSize(width: 50, height: 50))
        }

        balanceTitleLabel.snp.makeConstraints { (m) in
            m.left.equalTo(symbolLabel)
            m.top.equalTo(symbolLabel.snp.bottom).offset(20)
        }

        balanceLabel.snp.makeConstraints { (m) in
            m.left.equalTo(symbolLabel)
            m.right.equalTo(self).offset(-24)
            m.top.equalTo(balanceTitleLabel.snp.bottom).offset(2)
        }

        unconfirmedTitleLabel.snp.makeConstraints { (m) in
            m.left.equalTo(symbolLabel)
            m.top.equalTo(balanceLabel.snp.bottom).offset(16)
        }

        unconfirmedLabel.snp.makeConstraints { (m) in
            m.left.equalTo(symbolLabel)
            m.right.equalTo(self).offset(-24)
            m.top.equalTo(unconfirmedTitleLabel.snp.bottom).offset(2)
            m.bottom.equalTo(self).offset(-20)
        }

//        unconfirmedCountLabel.setContentHuggingPriority(.required, for: .horizontal)
//        unconfirmedCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
//        unconfirmedCountLabel.snp.makeConstraints { (m) in
//            m.left.equalTo(unconfirmedLabel.snp.right).offset(10)
//            m.right.equalTo(self).offset(-24)
//            m.centerY.equalTo(unconfirmedLabel)
//        }

        balanceTitleLabel.text = R.string.localizable.balanceInfoDetailBalanceTitle()
        unconfirmedTitleLabel.text = R.string.localizable.balanceInfoDetailUnconfirmedTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModelBehaviorRelay: BehaviorRelay<WalletHomeBalanceInfoViewModelType>) {
        viewModelBehaviorRelay.asObservable().bind { [weak self] in
            guard let `self` = self else { return }
            $0.token.icon.putIn(self.iconImageView)
            self.symbolLabel.text = $0.symbol
            self.balanceLabel.text = $0.balance.amountFull(decimals: $0.token.decimals)
            self.unconfirmedLabel.text = $0.unconfirmed.amountFull(decimals: $0.token.decimals)
//            self.unconfirmedCountLabel.text = R.string.localizable.balanceInfoDetailUnconfirmedCountTitle(String($0.unconfirmedCount))
            self.backgroundColors = $0.token.backgroundColors
            DispatchQueue.main.async {
                self.backgroundColor = GradientColor(.leftToRight, frame: self.frame, colors: self.backgroundColors)
            }
        }.disposed(by: rx.disposeBag)
    }
}
