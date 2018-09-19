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

    static func cellHeight() -> CGFloat {
        return 84
    }

    let addressLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.numberOfLines = 2
    }

    let flagImageView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(addressLabel)
        contentView.addSubview(flagImageView)

        addressLabel.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(contentView).offset(24)
        }

        flagImageView.setContentHuggingPriority(.required, for: .horizontal)
        flagImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        flagImageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(addressLabel.snp.right).offset(24)
            m.right.equalTo(contentView).offset(-24)
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

    func bind(viewModel: AddressManageAddressViewModelType) {
        addressLabel.text = viewModel.address
        flagImageView.image = viewModel.isSelected ? R.image.icon_cell_select() : R.image.icon_cell_unselect()
    }

}
