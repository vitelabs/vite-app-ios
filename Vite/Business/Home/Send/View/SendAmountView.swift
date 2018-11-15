//
//  SendAmountView.swift
//  Vite
//
//  Created by Stone on 2018/9/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class SendAmountView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let textField = UITextField().then {
        $0.font = AppStyle.descWord.font
    }

    let symbolLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.descWord.font
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = Colors.lineGray
    }

    init(amount: String, symbol: String) {
        super.init(frame: CGRect.zero)

        let canEdit = amount.isEmpty
        isUserInteractionEnabled = canEdit

        titleLabel.text = R.string.localizable.sendPageAmountTitle()
        textField.text = amount
        symbolLabel.text = symbol

        addSubview(titleLabel)
        addSubview(textField)
        addSubview(symbolLabel)
        addSubview(separatorLine)

        separatorLine.snp.makeConstraints { (m) in
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.equalTo(self)
            m.right.equalTo(self)
            m.bottom.equalTo(self)
        }

        if canEdit {

            titleLabel.snp.makeConstraints { (m) in
                m.top.equalTo(self).offset(20)
                m.left.equalTo(self)
                m.right.equalTo(self)
            }

            textField.textColor = Colors.cellTitleGray
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
            textField.snp.makeConstraints { (m) in
                m.left.equalTo(titleLabel)
                m.top.equalTo(titleLabel.snp.bottom).offset(10)
                m.bottom.equalTo(self).offset(-10)
            }

            symbolLabel.snp.makeConstraints { (m) in
                m.left.equalTo(textField.snp.right).offset(10)
                m.right.equalTo(titleLabel)
                m.centerY.equalTo(textField)
            }

        } else {

            titleLabel.snp.makeConstraints { (m) in
                m.top.equalTo(self).offset(20)
                m.left.equalTo(self)
                m.bottom.equalTo(self).offset(-20)
            }

            textField.textColor = Colors.titleGray
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            textField.snp.makeConstraints { (m) in
                m.left.equalTo(titleLabel.snp.right).offset(10)
                m.centerY.equalTo(titleLabel)
            }

            symbolLabel.snp.makeConstraints { (m) in
                m.left.equalTo(textField.snp.right).offset(10)
                m.right.equalTo(self)
                m.centerY.equalTo(titleLabel)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
