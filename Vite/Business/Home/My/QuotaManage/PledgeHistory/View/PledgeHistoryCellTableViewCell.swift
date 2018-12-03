//
//  PledgeHistoryCellTableViewCell.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/29.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

final class PledgeHistoryCell: UITableViewCell {

    let hashLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.lineBreakMode = .byTruncatingMiddle
    }

    let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x3E4A59).withAlphaComponent(0.45)
    }

    let balanceLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = UIColor(netHex: 0x3E4A59)
    }

    let symbolLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x3E4A59)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.separatorInset = UIEdgeInsets.init(top: 0, left: 24, bottom: 0, right: -24)
        self.selectionStyle = .none

        contentView.addSubview(hashLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(symbolLabel)

        hashLabel.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(16)
            m.left.equalTo(contentView.snp.left).offset(24)
        }

        timeLabel.snp.makeConstraints { (m) in
            m.top.equalTo(hashLabel.snp.bottom).offset(5)
            m.left.equalTo(hashLabel)
        }

        balanceLabel.setContentHuggingPriority(.required, for: .horizontal)
        balanceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        balanceLabel.snp.makeConstraints { (m) in
            m.top.equalTo(hashLabel)
            m.left.greaterThanOrEqualTo(hashLabel.snp.right).offset(22)
            m.left.greaterThanOrEqualTo(timeLabel.snp.right).offset(22)
            m.right.equalTo(contentView).offset(-24)
        }

        symbolLabel.snp.makeConstraints { (m) in
            m.right.equalTo(balanceLabel)
            m.top.equalTo(timeLabel)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
