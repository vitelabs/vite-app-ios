//
//  ReceiveShareFooterView.swift
//  Vite
//
//  Created by Stone on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class ReceiveShareFooterView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
        $0.text = R.string.localizable.receivePageTokenNoteLabel.key.localized()
    }

    let textLabel = UILabel().then {
        $0.textColor = Colors.cellTitleGray
        $0.font = AppStyle.descWord.font
        $0.numberOfLines = 0
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = Colors.lineGray
    }

    init(text: String?) {
        super.init(frame: CGRect.zero)

        textLabel.text = text

        addSubview(titleLabel)
        addSubview(textLabel)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
        }

        textLabel.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.left.right.equalTo(titleLabel)
        }

        separatorLine.snp.makeConstraints { (m) in
            m.top.equalTo(textLabel.snp.bottom).offset(10)
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.right.equalTo(titleLabel)
            m.bottom.equalTo(self).offset(-30)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
