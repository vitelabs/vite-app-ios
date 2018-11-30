//
//  TitleMoneyInputView.swift
//  Vite
//
//  Created by Water on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class TitleMoneyInputView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let textField = UITextField().then {
        $0.textColor = Colors.cellTitleGray
        $0.font = AppStyle.descWord.font
    }

    let symbolLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.descWord.font
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = Colors.lineGray
    }

    init(title: String, placeholder: String = "", content: String = "", desc: String = "") {
        super.init(frame: CGRect.zero)

        let attributedString = NSMutableAttributedString(string: placeholder)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: Colors.lineGray,
                                        NSAttributedString.Key.font: textField.font!], range: NSRange(location: 0, length: placeholder.count))

        titleLabel.text = title
        textField.text = content
        textField.attributedPlaceholder = attributedString
        symbolLabel.text = desc

        addSubview(titleLabel)
        addSubview(textField)
        addSubview(symbolLabel)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(self)
            m.height.equalTo(20)
        }

        textField.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.left.right.equalTo(self)
            m.height.equalTo(25)
        }

        symbolLabel.snp.makeConstraints { (m) in
            m.left.equalTo(textField.snp.right).offset(10)
            m.right.equalTo(self)
            m.width.equalTo(50)
            m.centerY.equalTo(textField)
        }
        symbolLabel.isHidden = true

        separatorLine.snp.makeConstraints { (m) in
            m.top.equalTo(textField.snp.bottom).offset(10)
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.right.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
