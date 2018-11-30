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

    fileprivate let flagImageView = UIImageView()

    fileprivate let addressLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.numberOfLines = 2
    }

    fileprivate let copyButton = UIButton().then {
        $0.setImage(R.image.icon_button_paste_light_gray(), for: .normal)
        $0.setImage(R.image.icon_button_paste_light_gray()?.highlighted, for: .highlighted)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(flagImageView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(copyButton)

        flagImageView.setContentHuggingPriority(.required, for: .horizontal)
        flagImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        flagImageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(contentView).offset(24)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.centerY.equalTo(contentView)
            m.left.equalTo(flagImageView.snp.right).offset(14)
        }

        let vLine = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0xe5e5ea)
        }

        contentView.addSubview(vLine)
        vLine.snp.makeConstraints { (m) in
            m.width.equalTo(CGFloat.singleLineWidth)
            m.left.equalTo(addressLabel.snp.right).offset(13)
            m.right.equalTo(contentView).offset(-57)
            m.top.bottom.equalTo(addressLabel)
        }

        copyButton.snp.makeConstraints { (m) in
            m.top.bottom.right.equalTo(contentView)
            m.width.equalTo(66)
        }

        let hLine = UIView().then {
            $0.backgroundColor = Colors.lineGray
        }

        contentView.addSubview(hLine)
        hLine.snp.makeConstraints { (m) in
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
        copyButton.rx.tap.bind { viewModel.copy() }.disposed(by: disposeBag)
    }

}
