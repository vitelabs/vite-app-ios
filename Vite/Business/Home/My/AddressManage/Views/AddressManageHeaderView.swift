//
//  AddressManageHeaderView.swift
//  Vite
//
//  Created by Stone on 2018/9/19.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class AddressManageHeaderView: UIView {

    let titleLabel = UILabel().then {
        $0.text = R.string.localizable.addressManageDefaultAddressCellTitle.key.localized()
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x3E4A59)
    }

    let addressLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.numberOfLines = 2
    }

    let addressListTitleLabel = UILabel().then {
        $0.text = R.string.localizable.addressManageAddressHeaderTitle.key.localized()
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(netHex: 0x3E4A59)
    }

    let tipButton = UIButton().then {
        $0.setImage(R.image.icon_button_infor(), for: .normal)
        $0.setImage(R.image.icon_button_infor()?.highlighted, for: .highlighted)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let backView = UIView()

        backView.backgroundColor = UIColor(netHex: 0x007AFF).withAlphaComponent(0.06)
        backView.layer.borderColor = UIColor(netHex: 0x007AFF).withAlphaComponent(0.12).cgColor
        backView.layer.borderWidth = CGFloat.singleLineWidth

        addSubview(backView)
        addSubview(addressListTitleLabel)
        addSubview(tipButton)

        backView.addSubview(titleLabel)
        backView.addSubview(addressLabel)

        backView.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(self)
        }

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(backView).offset(16)
            m.left.equalTo(backView).offset(24)
            m.right.equalTo(backView).offset(-24)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(11)
            m.left.right.equalTo(titleLabel)
            m.bottom.equalTo(backView).offset(-13)
        }

        addressListTitleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(backView.snp.bottom).offset(20)
            m.left.equalTo(self).offset(24)
            m.bottom.equalTo(self).offset(-20)
        }

        tipButton.snp.makeConstraints { (m) in
            m.left.equalTo(addressListTitleLabel.snp.right).offset(10)
            m.centerY.equalTo(addressListTitleLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
