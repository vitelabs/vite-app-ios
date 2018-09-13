//
//  AddressManageAddressHeaderCell.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class AddressManageAddressHeaderCell: BaseTableViewCell {

    let titleLabel = UILabel().then {
        $0.text = R.string.localizable.addressManageAddressHeaderTitle()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.top.bottom.left.right.equalTo(contentView)
            m.height.equalTo(40)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
