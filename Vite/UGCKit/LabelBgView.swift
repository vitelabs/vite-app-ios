//
//  LabelBgView.swift
//  Vite
//
//  Created by Water on 2018/11/8.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class LabelBgView: UIView {
    let titleLab = UILabel().then {
        $0.textAlignment = .center
    }

    let bgImg = UIImageView().then {
        $0.image = R.image.btn_path_bg()
    }

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear

        addSubview(bgImg)
        addSubview(titleLab)

        bgImg.snp.makeConstraints { (m) in
            m.edges.equalTo(self)
        }
        titleLab.snp.makeConstraints { (m) in
           m.top.bottom.equalTo(self)
           m.left.equalTo(self).offset(6)
           m.right.equalTo(self).offset(-6)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
