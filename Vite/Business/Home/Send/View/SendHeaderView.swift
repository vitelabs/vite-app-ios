//
//  SendHeaderView.swift
//  Vite
//
//  Created by Stone on 2018/9/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class SendHeaderView: UIView {

    let addressTitleLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.text = R.string.localizable.sendPageMyAddressTitle.key.localized()
    }

    let addressLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.numberOfLines = 2
    }

    let balanceTitleLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.text = R.string.localizable.sendPageMyBalanceTitle.key.localized()
    }

    let balanceLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }

    let quotaTitleLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.text = R.string.localizable.sendPageMyQuotaTitle.key.localized()
    }

    let quotaLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }

    let maxTxCountTitleLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.text = R.string.localizable.sendPageMyMaxTxCountTitle.key.localized()
    }

    let maxTxCountLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }

    init(address: String) {
        super.init(frame: CGRect.zero)
        addressLabel.text = address

        let contentView = createContentViewAndSetShadow(width: 0, height: 5, radius: 9)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 2

        let line = UIView().then { $0.backgroundColor = UIColor(netHex: 0x759BFA) }

        contentView.addSubview(line)
        contentView.addSubview(addressTitleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(balanceTitleLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(quotaTitleLabel)
        contentView.addSubview(quotaLabel)
        contentView.addSubview(maxTxCountTitleLabel)
        contentView.addSubview(maxTxCountLabel)

        line.snp.makeConstraints({ (m) in
            m.top.bottom.left.equalTo(contentView)
            m.width.equalTo(3)
        })

        addressTitleLabel.snp.makeConstraints({ (m) in
            m.top.equalTo(contentView).offset(16)
            m.left.equalTo(contentView).offset(19)
            m.right.equalTo(contentView).offset(-16)
        })

        addressLabel.snp.makeConstraints({ (m) in
            m.top.equalTo(addressTitleLabel.snp.bottom).offset(8)
            m.left.right.equalTo(addressTitleLabel)
        })

        balanceTitleLabel.snp.makeConstraints({ (m) in
            m.top.equalTo(addressLabel.snp.bottom).offset(16)
            m.left.right.equalTo(addressTitleLabel)
        })

        balanceLabel.snp.makeConstraints({ (m) in
            m.top.equalTo(balanceTitleLabel.snp.bottom).offset(8)
            m.left.right.equalTo(addressTitleLabel)
        })

        quotaTitleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(balanceLabel.snp.bottom).offset(16)
            m.left.right.equalTo(addressTitleLabel)
        }

        quotaLabel.snp.makeConstraints { (m) in
            m.top.equalTo(quotaTitleLabel.snp.bottom).offset(8)
            m.left.right.equalTo(addressTitleLabel)
        }

        maxTxCountTitleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(quotaLabel.snp.bottom).offset(16)
            m.left.right.equalTo(addressTitleLabel)
        }

        maxTxCountLabel.snp.makeConstraints { (m) in
            m.top.equalTo(maxTxCountTitleLabel.snp.bottom).offset(8)
            m.left.equalTo(addressTitleLabel)
            m.bottom.equalTo(contentView).offset(-16)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
