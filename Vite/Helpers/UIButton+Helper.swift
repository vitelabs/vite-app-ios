//
//  UIButton+Helper.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

extension UIButton {

    enum Style {
        case blue
        case white
    }

    convenience init(style: Style, title: String? = nil) {
        self.init()

        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        snp.makeConstraints { $0.height.equalTo(50) }

        switch style {
        case .blue:
            setTitleColor(UIColor.white, for: .normal)
            setBackgroundImage(R.image.background_button_blue()?.resizable, for: .normal)
            setBackgroundImage(R.image.background_button_blue()?.highlighted.resizable, for: .highlighted)
        case .white:
            setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
            setBackgroundImage(R.image.background_button_white()?.resizable, for: .normal)
            setBackgroundImage(R.image.background_button_white()?.tintColor(UIColor(netHex: 0xf5f5f5)).resizable, for: .highlighted)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.1
            self.layer.shadowRadius = 3
            self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            self.layer.cornerRadius = 2
        }
    }

}
