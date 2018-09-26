//
//  SendNoteView.swift
//  Vite
//
//  Created by Stone on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class SendNoteView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let textField = UITextField().then {
        $0.textColor = Colors.cellTitleGray
        $0.font = AppStyle.descWord.font
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = UIColor(netHex: 0xD3DFEF)
    }

    init(note: String, canEdit: Bool = true) {
        super.init(frame: CGRect.zero)

        titleLabel.text = R.string.localizable.sendPageRemarkTitle()
        textField.text = note
        textField.isUserInteractionEnabled = canEdit

        addSubview(titleLabel)
        addSubview(textField)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(20)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
        }

        textField.snp.makeConstraints { (m) in
            m.left.right.equalTo(titleLabel)
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.bottom.equalTo(self).offset(-10)
        }

        separatorLine.snp.makeConstraints { (m) in
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
            m.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
