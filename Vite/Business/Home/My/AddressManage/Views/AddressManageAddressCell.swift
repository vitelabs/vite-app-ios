//
//  AddressManageAddressCell.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class AddressManageAddressCell: BaseTableViewCell {

    let numberLabel = UILabel().then {
        $0.text = R.string.localizable.addressManageDefaultAddressCellTitle()
    }

    let addressLabel = UILabel().then {
        $0.textColor = UIColor.red
        $0.numberOfLines = 2
    }

    let flagImageView = UIImageView(image: R.image.icon_address_manage_selected())

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(numberLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(flagImageView)

        numberLabel.setContentHuggingPriority(.required, for: .horizontal)
        numberLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        numberLabel.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(contentView).offset(15)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(10)
            m.left.equalTo(numberLabel.snp.right).offset(10)
            m.bottom.equalTo(contentView).offset(-10)
        }

        flagImageView.setContentHuggingPriority(.required, for: .horizontal)
        flagImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        flagImageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(addressLabel.snp.right).offset(10)
            m.right.equalTo(contentView).offset(-10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModel: AddressManageAddressViewModelType) {
        numberLabel.text = String(viewModel.number)
        addressLabel.text = viewModel.address
        flagImageView.isHidden = !viewModel.isSelected
    }

}
