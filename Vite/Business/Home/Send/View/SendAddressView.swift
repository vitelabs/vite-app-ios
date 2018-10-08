//
//  SendAddressView.swift
//  Vite
//
//  Created by Stone on 2018/9/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class SendAddressView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let textView = UITextView().then {
        $0.backgroundColor = UIColor.clear
    }

    init(address: String) {
        super.init(frame: CGRect.zero)

        let canEdit = address.isEmpty
        isUserInteractionEnabled = canEdit

        titleLabel.text = R.string.localizable.sendPageToAddressTitle.key.localized()
        textView.text = address

        addSubview(titleLabel)
        addSubview(textView)

        if canEdit {

            titleLabel.snp.makeConstraints { (m) in
                m.top.equalTo(self)
                m.left.equalTo(self).offset(24)
                m.right.equalTo(self).offset(-24)
            }

            textView.snp.makeConstraints { (m) in
                m.top.equalTo(titleLabel.snp.bottom).offset(10)
                m.left.right.equalTo(titleLabel)
                m.height.equalTo(55)
                m.bottom.equalTo(self)
            }

            textView.textColor = UIColor(netHex: 0x24272B)
            textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)

            let separatorLine = UIView()
            separatorLine.backgroundColor = Colors.lineGray
            addSubview(separatorLine)
            separatorLine.snp.makeConstraints { (m) in
                m.height.equalTo(CGFloat.singleLineWidth)
                m.left.right.equalTo(titleLabel)
                m.bottom.equalTo(self)
            }

        } else {
            titleLabel.snp.makeConstraints { (m) in
                m.top.equalTo(self).offset(16)
                m.left.equalTo(self).offset(24)
                m.right.equalTo(self).offset(-24)
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
            backView.snp.makeConstraints { (m) in m.edges.equalTo(self) }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
