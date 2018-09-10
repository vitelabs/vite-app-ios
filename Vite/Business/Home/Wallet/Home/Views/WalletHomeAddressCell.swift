//
//  WalletHomeAddressCell.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WalletHomeAddressCell: BaseTableViewCell {

    fileprivate let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor.red
    }

    fileprivate let addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = UIColor.green
        $0.numberOfLines = 2
    }

    fileprivate let copyButton = UIButton().then {
        $0.setImage(R.image.home_wallet_address_copy(), for: .normal)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(copyButton)

        nameLabel.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(5)
            m.left.equalTo(contentView).offset(15)
        }

        copyButton.snp.makeConstraints { (m) in
            m.centerY.equalTo(nameLabel)
            m.left.equalTo(nameLabel.snp.right).offset(5)
            m.right.equalTo(contentView).offset(-15)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.top.equalTo(nameLabel.snp.bottom).offset(5)
            m.left.equalTo(nameLabel)
            m.right.equalTo(copyButton)
            m.bottom.equalTo(contentView).offset(-5)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModel: WalletHomeAddressViewModelType) {
        viewModel.nameDriver.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.defaultAddressDriver.drive(addressLabel.rx.text).disposed(by: disposeBag)
        copyButton.rx.tap.bind {
            viewModel.copy()
        }.disposed(by: disposeBag)
    }
}
