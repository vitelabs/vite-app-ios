//
//  NavigationTitleView.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class NavigationTitleView: UIView {

    enum Style {
        case `default`
        case white
        case custom(color: UIColor)
    }

    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
    }

    init(title: String?, style: Style = .default) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(6)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
            m.bottom.equalTo(self).offset(-20)
//            m.height.equalTo(28)
        }

        switch style {
        case .default:
            titleLabel.textColor = UIColor(netHex: 0x24272B)
            backgroundColor = UIColor.white
        case .white:
            titleLabel.textColor = UIColor.white
            backgroundColor = UIColor.clear
        case .custom(let color):
            titleLabel.textColor = color
            backgroundColor = UIColor.clear
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
