//
//  WalletHomeTokenCell.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class WalletHomeTokenCell: BaseTableViewCell {

    fileprivate let iconImageView = UIImageView()

    fileprivate let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    fileprivate let balanceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.green
        $0.numberOfLines = 1
    }

    fileprivate let unconfirmedLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = UIColor.green
        $0.numberOfLines = 1
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(unconfirmedLabel)

        iconImageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(contentView).offset(15)
        }

        nameLabel.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(iconImageView.snp.right).offset(10)
        }

        balanceLabel.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(10)
            m.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(10)
            m.right.equalTo(contentView).offset(-15)
        }

        unconfirmedLabel.snp.makeConstraints { (m) in
            m.top.equalTo(balanceLabel.snp.bottom).offset(5)
            m.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(10)
            m.right.equalTo(contentView).offset(-15)
            m.bottom.equalTo(contentView).offset(-10)
        }

        iconImageView.image = R.image.icon_wallet_token_vite()
        nameLabel.text = "Vite"
        balanceLabel.text = "1234567890"
        unconfirmedLabel.text = "8769"

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
