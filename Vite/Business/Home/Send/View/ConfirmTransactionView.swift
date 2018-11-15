//
//  ConfirmTransactionView.swift
//  Vite
//
//  Created by haoshenyang on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class ConfirmTransactionView: UIView {

    var type: ConfirmTransactionViewController.ConfirmTransactionType = .password {
        didSet {
            var view: UIView!
            if type == .password {
                titleLabel.text = R.string.localizable.confirmTransactionPageUsePasswordTitle()
                confirmButton.removeFromSuperview()
                self.addSubview(passwordView)
                enterPasswordButton.isHidden = true
                _ = passwordView.becomeFirstResponder()
                view = passwordView
            } else {
                titleLabel.text = R.string.localizable.confirmTransactionPageTitle()
                passwordView.removeFromSuperview()
                self.addSubview(confirmButton)
                view = confirmButton
            }
            view.snp.makeConstraints { (m) in
                m.centerX.equalTo(self)
                m.leading.trailing.equalTo(transactionInfoView)
                m.bottom.equalTo(self).offset(-24)
                m.height.equalTo(50)
            }
        }
    }

    let closeButton = UIButton().then {
        $0.setImage(R.image.icon_nav_close_black(), for: .normal)
    }

    let titleLabel = UILabel().then {
        $0.text = R.string.localizable.confirmTransactionPageTitle()
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }

    let enterPasswordButton = UIButton().then {
        $0.setTitleColor(UIColor.init(netHex: 0x007AFF), for: .normal)
        $0.setTitle(R.string.localizable.confirmTransactionPageUsePassword(), for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }

    let transactionInfoView = TransactionInfoView()

    var tokenLabel: UILabel {
        return transactionInfoView.tokenLabel
    }

    var infoTitleLabel: UILabel {
        return transactionInfoView.titleLabel
    }

    var infoLabel: UILabel {
        return transactionInfoView.addressLabel
    }

    var amountLabel: UILabel {
        return transactionInfoView.amountLabel
    }

    let confirmButton = UIButton().then {
        $0.backgroundColor = UIColor.init(netHex: 0x007AFF)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.layer.cornerRadius = 2.0
    }

    let passwordView = PasswordInputView(type: .bordered).then {
        $0.secretType = .point
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(netHex: 0xffffff)

        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(transactionInfoView)
        addSubview(enterPasswordButton)
        addSubview(confirmButton)

        closeButton.snp.makeConstraints { (m) in
            m.width.height.equalTo(30)
            m.top.equalTo(self).offset(16)
            m.leading.equalTo(self).offset(20)
        }

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(19)
            m.centerX.equalTo(self)
        }

        enterPasswordButton.snp.makeConstraints { (m) in
            m.height.equalTo(30)
            m.top.equalTo(self).offset(16)
            m.trailing.equalTo(self).offset(-20)
        }

        transactionInfoView.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(60)
            m.leading.equalTo(self).offset(24)
            m.trailing.equalTo(self).offset(-24)
            m.height.equalTo(176)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
