//
//  IconBtnView.swift
//  Vite
//
//  Created by Water on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class IconBtnView: UIImageView {

    let  iconView = UIImageView().then {
        $0.backgroundColor = .clear
    }

    let btn = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    init(iconImg: UIImage, text: String = "") {
        super.init(frame: CGRect.zero)
        self.isUserInteractionEnabled = true
        self.image = R.image.background_button_blue()?.resizable
        self.highlightedImage = R.image.background_button_blue()?.tintColor(UIColor(netHex: 0x006FEA)).resizable
        iconView.image =  iconImg
        btn.setTitle(text, for: .normal)

        addSubview(iconView)
        addSubview(btn)

        iconView.snp.makeConstraints { (m) in
            m.centerY.equalTo(self)
            m.width.equalTo(20)
            m.height.equalTo(20)
            m.left.equalTo(self).offset(16)
        }

        btn.snp.makeConstraints { (m) in
            m.centerY.right.equalTo(self)
            m.left.equalTo(iconView.snp.right)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
