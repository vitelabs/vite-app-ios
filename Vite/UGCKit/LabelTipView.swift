//
//  LabelTipView.swift
//  Vite
//
//  Created by Water on 2018/11/8.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class LabelTipView: UIView {
    let titleLab = UILabel().then {
        $0.textColor = .black
        $0.font = Fonts.Font17
        $0.textAlignment = .center
    }

    let tipButton = UIButton().then {
        $0.setImage(R.image.icon_button_infor(), for: .normal)
        $0.setImage(R.image.icon_button_infor()?.highlighted, for: .highlighted)
    }

    init(_ title: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        titleLab.text = title
        self.setupShadow(CGSize(width: 0, height: 5))

        addSubview(titleLab)
        addSubview(tipButton)

        titleLab.snp.makeConstraints { (m) in
            m.left.top.bottom.equalTo(self)
        }

        tipButton.snp.makeConstraints { (m) in
            m.centerY.equalTo(titleLab)
            m.left.equalTo(titleLab.snp.right).offset(10)
            m.right.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

