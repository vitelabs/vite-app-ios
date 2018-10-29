//
//  CardBgView.swift
//  Vite
//
//  Created by Water on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class CardBgView: UIView {

    let closeBtn = UIButton().then {
        $0.setImage(R.image.icon_nav_close_black(), for: .normal)
    }

    let titleLab = UILabel().then {
        $0.textColor = .black
        $0.font = Fonts.Font17
        $0.textAlignment = .center
    }

    init(title: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        titleLab.text = title
        self.setupShadow(CGSize(width: 0, height: 5))

        addSubview(closeBtn)
        addSubview(titleLab)

        closeBtn.snp.makeConstraints { (m) in
            m.left.equalTo(self).offset(24)
            m.top.equalTo(self).offset(17)
            m.width.height.equalTo(28)
        }

        titleLab.snp.makeConstraints { (m) in
            m.left.right.equalTo(self)
            m.centerY.equalTo(closeBtn)
            m.height.equalTo(20)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
