//
//  IconLabelView.swift
//  Vite
//
//  Created by Water on 2018/11/8.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class IconLabelView: UIView {
    let titleLab = UILabel().then {
        $0.textAlignment = .left
    }

    let tipButton = UIButton().then {
        $0.setImage(R.image.icon_button_infor(), for: .normal)
        $0.setImage(R.image.icon_button_infor()?.highlighted, for: .highlighted)
    }

    init(_ title: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        titleLab.text = title

        addSubview(titleLab)
        addSubview(tipButton)

        tipButton.snp.makeConstraints { (m) in
            m.left.top.bottom.equalTo(self)
        }
        titleLab.snp.makeConstraints { (m) in
            m.top.bottom.right.equalTo(self)
            m.left.equalTo(tipButton.snp.right).offset(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
