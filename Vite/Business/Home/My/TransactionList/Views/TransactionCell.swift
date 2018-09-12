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

    fileprivate let typeImageView = UIImageView()

    fileprivate let hashLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
        $0.lineBreakMode = .byTruncatingMiddle
    }

    fileprivate let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    fileprivate let balanceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(typeImageView)
        contentView.addSubview(hashLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(balanceLabel)

        typeImageView.setContentHuggingPriority(.required, for: .horizontal)
        typeImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        typeImageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(contentView).offset(10)
        }

        hashLabel.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(10)
            m.left.equalTo(typeImageView.snp.right).offset(10)
        }

        timeLabel.snp.makeConstraints { (m) in
            m.top.equalTo(hashLabel.snp.bottom).offset(5)
            m.left.equalTo(hashLabel)
            m.bottom.equalTo(contentView).offset(-250)
        }

        balanceLabel.setContentHuggingPriority(.required, for: .horizontal)
        balanceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        balanceLabel.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.greaterThanOrEqualTo(hashLabel.snp.right).offset(10)
            m.left.greaterThanOrEqualTo(timeLabel.snp.right).offset(10)
            m.right.equalTo(contentView).offset(-10)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModel: TransactionViewModelType, index: Int) {
        typeImageView.image = viewModel.typeImage
        hashLabel.text = viewModel.hash
        timeLabel.text = String(index)//viewModel.timeString
        balanceLabel.text = viewModel.balanceString
    }

}
