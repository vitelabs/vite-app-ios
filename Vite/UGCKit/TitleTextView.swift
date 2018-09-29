//
//  TitleTextView.swift
//  Vite
//
//  Created by Water on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class TitleTextView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = UIColor.blue
        $0.font = UIFont.systemFont(ofSize: 17)
    }

    let textView = UITextView().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 25)
    }

    let separatorLine = UIView().then {
        $0.backgroundColor = UIColor(netHex: 0xD3DFEF)
    }

    init(title: String, text: String = "") {
        super.init(frame: CGRect.zero)

        titleLabel.text = title
        textView.text = text

        addSubview(titleLabel)
        addSubview(textView)
        addSubview(separatorLine)

        titleLabel.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(self)
        }

        textView.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(5)
            m.left.right.equalTo(self)
        }

        separatorLine.snp.makeConstraints { (m) in
            m.top.equalTo(textView.snp.bottom)
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.right.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
