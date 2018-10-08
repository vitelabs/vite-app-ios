//
//  TitleBtnView.swift
//  Vite
//
//  Created by Water on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class TitleBtnView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.font = AppStyle.formHeader.font
    }

    let btn = UIButton().then {
        $0.setTitleColor(Colors.descGray, for: .normal)
        $0.setTitleColor(Colors.descGray, for: .highlighted)
        $0.titleLabel?.font = AppStyle.inputDescWord.font
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = Colors.lineGray
    }

    init(title: String, text: String = "") {
        super.init(frame: CGRect.zero)

        titleLabel.text = title
        btn.setTitle(text, for: .normal)

        addSubview(titleLabel)
        addSubview(btn)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(self)
        }

        btn.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom)
            m.left.right.equalTo(self)
        }

        separatorLine.snp.makeConstraints { (m) in
            m.top.equalTo(btn.snp.bottom)
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.right.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
