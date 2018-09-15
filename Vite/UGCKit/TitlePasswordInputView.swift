//
//  TitlePasswordInputView.swift
//  Vite
//
//  Created by Water on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class TitlePasswordInputView: UIView {

    let titleLabel = UILabel().then {
        $0.textColor = UIColor.blue
        $0.font = UIFont.systemFont(ofSize: 17)
    }

    let passwordInputView = PasswordInputView()

    init(title: String) {
        super.init(frame: CGRect.zero)

        titleLabel.text = title

        addSubview(titleLabel)
        addSubview(passwordInputView)

        titleLabel.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(self)
        }

        passwordInputView.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom)
            m.left.right.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
