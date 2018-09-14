//
//  PrimaryButton.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {

    init(title: String?) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.blue

        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor(white: 1, alpha: 0.6), for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
