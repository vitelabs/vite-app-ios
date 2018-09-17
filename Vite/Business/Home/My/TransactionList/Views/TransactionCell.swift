//
//  TransactionCell.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TransactionCell: BaseTableViewCell {

    static var cellHeight: CGFloat {
        return 72
    }

    fileprivate let typeImageView = UIImageView()

    fileprivate let hashLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.lineBreakMode = .byTruncatingMiddle
    }

    fileprivate let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x3E4A59).withAlphaComponent(0.45)
    }

    fileprivate let balanceLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = UIColor(netHex: 0x3E4A59)
    }

    fileprivate let symbolLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x3E4A59)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(typeImageView)
        contentView.addSubview(hashLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(symbolLabel)

        typeImageView.setContentHuggingPriority(.required, for: .horizontal)
        typeImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        typeImageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(contentView).offset(24)
        }

        hashLabel.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(16)
            m.left.equalTo(typeImageView.snp.right).offset(10)
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

        let line = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0xD3DFEF)
        }

        contentView.addSubview(line)
        line.snp.makeConstraints { (m) in
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.equalTo(contentView).offset(24)
            m.right.equalTo(contentView).offset(-24)
            m.bottom.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModel: TransactionViewModelType, index: Int) {
        typeImageView.image = viewModel.typeImage
        hashLabel.text = viewModel.hash
        timeLabel.text = viewModel.timeString
        balanceLabel.text = viewModel.balanceString
        symbolLabel.text = viewModel.symbolString
    }

}
