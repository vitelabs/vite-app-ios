//
//  TitleDescView.swift
//  Vite
//
//  Created by Water on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class TitleDescView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let descLab = UILabel().then {
        $0.textColor = Colors.lineGray
        $0.font = AppStyle.descWord.font
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = Colors.lineGray
    }

    init(title: String, desc: NSAttributedString = NSAttributedString(string: "") ) {
        super.init(frame: CGRect.zero)

        titleLabel.text = title
        descLab.attributedText = desc

        addSubview(titleLabel)
        addSubview(descLab)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(self)
            m.height.equalTo(20)
        }

        descLab.snp.makeConstraints { (m) in
            m.right.equalTo(titleLabel)
            m.centerY.equalTo(titleLabel)
        }

        separatorLine.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.right.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
