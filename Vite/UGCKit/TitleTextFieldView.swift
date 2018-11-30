//
//  TitleTextFieldView.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class TitleTextFieldView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let textField = UITextField().then {
        $0.textColor = Colors.cellTitleGray
        $0.font = AppStyle.descWord.font
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = Colors.lineGray
    }

    init(title: String, placeholder: String = "", text: String = "") {
        super.init(frame: CGRect.zero)

        let attributedString = NSMutableAttributedString(string: placeholder)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.green,
                                        NSAttributedString.Key.font: textField.font!, ], range: NSRange(location: 0, length: placeholder.count))

        titleLabel.text = title
        textField.text = text
        textField.attributedPlaceholder = attributedString

        addSubview(titleLabel)
        addSubview(textField)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(self)
        }

        textField.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.left.right.equalTo(self)
        }

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
