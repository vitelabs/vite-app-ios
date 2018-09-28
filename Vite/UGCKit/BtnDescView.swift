//
//  BtnDescView.swift
//  Vite
//
//  Created by Water on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class BtnDescView: UIView {

    lazy var btn: UIButton = {
        let btn = UIButton.init(style: .whiteWithoutShadow)
        return btn
    }()

    let titleLabel = UILabel().then {
        $0.textColor = Colors.titleGray
        $0.textAlignment = .center
        $0.font = AppStyle.formHeader.font
    }

    init(title: String) {
        super.init(frame: CGRect.zero)

        titleLabel.text = title
        addSubview(btn)
        addSubview(titleLabel)

        btn.snp.makeConstraints { (m) in
            m.top.centerX.equalTo(self)
            m.width.height.equalTo(70)
        }

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(btn.snp.bottom).offset(20)
            m.left.right.equalTo(self)
            m.height.equalTo(20)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
