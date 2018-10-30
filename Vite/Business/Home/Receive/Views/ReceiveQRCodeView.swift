//
//  ReceiveQRCodeView.swift
//  Vite
//
//  Created by Stone on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class ReceiveQRCodeView: UIView {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(20)
            m.centerX.equalTo(self)
            m.size.equalTo(CGSize(width: 170, height: 170))
            m.bottom.equalTo(self).offset(-20)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
