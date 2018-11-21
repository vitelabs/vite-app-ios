//
//  AddressLabelView.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class SendAddressViewType: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let textView = UITextView().then {
        $0.backgroundColor = UIColor.clear
    }

    let placeholderLab = UILabel().then {
        $0.backgroundColor = UIColor.clear
    }
}

class AddressLabelView: SendAddressViewType {

    init(address: String) {
        super.init(frame: CGRect.zero)

        isUserInteractionEnabled = false

        titleLabel.text = R.string.localizable.sendPageToAddressTitle()
        textView.text = address

        addSubview(titleLabel)
        addSubview(textView)

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(16)
            m.left.equalTo(self)
            m.right.equalTo(self)
        }

        textView.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.left.right.equalTo(titleLabel)
            m.height.equalTo(50)
            m.bottom.equalTo(self).offset(-16)
        }

        textView.textColor = UIColor(netHex: 0x3E4A59)
        textView.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        let backView = UIView()
        backView.backgroundColor = UIColor(netHex: 0x007AFF).withAlphaComponent(0.06)
        backView.layer.borderColor = UIColor(netHex: 0x007AFF).withAlphaComponent(0.12).cgColor
        backView.layer.borderWidth = CGFloat.singleLineWidth
        insertSubview(backView, at: 0)
        backView.snp.makeConstraints { (m) in
            m.top.bottom.equalTo(self)
            m.left.equalTo(self).offset(-24)
            m.right.equalTo(self).offset(24)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
