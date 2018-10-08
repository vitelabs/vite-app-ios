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

    let balanceLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }

    init(address: String) {
        super.init(frame: CGRect.zero)

        layer.masksToBounds = true
        layer.cornerRadius = 2

        let addressTitleLabel = UILabel().then {
            $0.textColor = UIColor(netHex: 0x3E4A59)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            $0.text = R.string.localizable.sendPageMyAddressTitle.key.localized()
        }

        let addressLabel = UILabel().then {
            $0.textColor = UIColor(netHex: 0x3E4A59)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            $0.numberOfLines = 2
            $0.text = address
        }

        let balanceTitleLabel = UILabel().then {
            $0.textColor = UIColor(netHex: 0x3E4A59)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            $0.text = R.string.localizable.sendPageMyBalanceTitle.key.localized()
        }

        let line = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0x759BFA)
        }

        addSubview(line)
        addSubview(addressTitleLabel)
        addSubview(addressLabel)
        addSubview(balanceTitleLabel)
        addSubview(balanceLabel)

        line.snp.makeConstraints({ (m) in
            m.top.bottom.left.equalTo(self)
            m.width.equalTo(3)
        })

        addressTitleLabel.snp.makeConstraints({ (m) in
            m.top.equalTo(self).offset(16)
            m.left.equalTo(self).offset(19)
            m.right.equalTo(self).offset(-16)
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
            m.top.equalTo(balanceTitleLabel.snp.bottom).offset(16)
            m.left.right.equalTo(addressTitleLabel)
            m.bottom.equalTo(self).offset(-16)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
