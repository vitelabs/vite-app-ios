//
//  AddressManageDefaultAddressCell.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class AddressManageDefaultAddressCell: BaseTableViewCell {

    let titleLabel = UILabel().then {
        $0.text = R.string.localizable.addressManageDefaultAddressCellTitle.key.localized()
    }

    let addressLabel = UILabel().then {
        $0.textColor = UIColor.red
        $0.numberOfLines = 2
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(15)
            m.left.equalTo(contentView).offset(15)
            m.right.equalTo(contentView).offset(-15)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.left.right.equalTo(titleLabel)
            m.bottom.equalTo(contentView).offset(-15)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(address: String) {
        addressLabel.text = address
    }

}
