//
//  WebToolBarView.swift
//  Vite
//
//  Created by Water on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class WebToolBarView: UIView {

    init() {
        super.init(frame: CGRect.zero)

        self.addSubview(goBackBtn)
        goBackBtn.snp.remakeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self)
        }
        self.addSubview(goNextBtn)
        goNextBtn.snp.remakeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self)
        }
        self.addSubview(reloadBtn)
        reloadBtn.snp.remakeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.right.equalTo(self).offset(-80)
            make.top.equalTo(self)
        }

        self.backgroundColor = .white
    }

    lazy var goNextBtn: UIButton = {
        let goNextBtn = UIButton.init(style: .blue)
        goNextBtn.setTitle("next", for: .normal)
        return goNextBtn
    }()
    lazy var goBackBtn: UIButton = {
        let goBackBtn = UIButton.init(style: .blue)
        goBackBtn.setTitle("back", for: .normal)
        return goBackBtn
    }()

    lazy var reloadBtn: UIButton = {
        let reloadBtn = UIButton.init(style: .blue)
        reloadBtn.setTitle("reload", for: .normal)
        return reloadBtn
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
