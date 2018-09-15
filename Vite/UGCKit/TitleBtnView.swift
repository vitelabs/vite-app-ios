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
        $0.textColor = UIColor.blue
        $0.font = UIFont.systemFont(ofSize: 17)
    }

    let btn = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = UIColor.blue
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
