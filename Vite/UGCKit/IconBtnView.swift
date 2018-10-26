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

    let btn = UIButton()

    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = UIColor.init(netHex: 0xA1A9CB)
        $0.textAlignment = .center
    }

    init(iconImg: UIImage, text: String = "") {
        super.init(frame: CGRect.init(x: 1, y: 1, width: 1, height: 1))
        self.isUserInteractionEnabled = true
        self.image = R.image.icon_background()?.resizable
        iconView.image =  iconImg
        titleLabel.text = text

        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(btn)

        iconView.snp.makeConstraints { (m) in
            m.centerX.equalTo(self)
            m.width.equalTo(32)
            m.height.equalTo(32)
            m.top.equalTo(self).offset(10)
        }

        titleLabel.snp.makeConstraints { (m) in
            m.centerX.right.equalTo(self)
            m.top.equalTo(iconView.snp.bottom)
        }

        btn.snp.makeConstraints { (m) in
            m.edges.equalTo(self)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
