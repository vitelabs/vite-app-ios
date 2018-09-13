//
//  ManageWalletHeaderView.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class ManageWalletHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.nameLab)
        self.nameLab.snp.makeConstraints {  (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(30)
        }

        self.addSubview(self.addressLab)
        self.addressLab.snp.makeConstraints {  (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self.nameLab.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }

    lazy var nameLab: UILabel = {
        let nameLab =  UILabel()
        nameLab.text = "ddd"
        nameLab.textAlignment = .center
        nameLab.textColor = .black
        return nameLab
    }()

    lazy var addressLab: UILabel = {
        let addressLab =  UILabel()
        addressLab.text = "vite_ddd"
        addressLab.textAlignment = .center
        addressLab.textColor = .black
        addressLab.numberOfLines = 2
        return addressLab
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
