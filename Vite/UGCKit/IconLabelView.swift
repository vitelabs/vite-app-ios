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

    let tipImg = UIImageView().then {
        $0.image = R.image.icon_votecount()
    }

    init(_ title: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        titleLab.text = title

        addSubview(titleLab)
        addSubview(tipImg)

        tipImg.snp.makeConstraints { (m) in
            m.left.centerY.equalTo(self)
        }
        titleLab.snp.makeConstraints { (m) in
            m.top.bottom.right.equalTo(self)
            m.left.equalTo(tipImg.snp.right).offset(4)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
