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

        self.addSubview(self.nameTitleLab)
        self.nameTitleLab.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(24)
            make.top.equalTo(self)
            make.height.equalTo(20)
        }

        self.addSubview(self.nameLab)
        self.nameLab.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(24)
            make.bottom.equalTo(self).offset(-19)
            make.height.equalTo(20)
        }
    }

    lazy var nameTitleLab: UILabel = {
        let nameTitleLab =  UILabel()
        nameTitleLab.text = R.string.localizable.manageWalletPageNameCellTitle.key.localized()
        nameTitleLab.textAlignment = .left
        nameTitleLab.textColor =  Colors.titleGray
        nameTitleLab.adjustsFontSizeToFitWidth = true
        return nameTitleLab
    }()

    lazy var nameLab: UILabel = {
        let nameLab =  UILabel()
        nameLab.text = WalletDataService.shareInstance.defaultWalletAccount?.name
        nameLab.textAlignment = .left
        nameLab.adjustsFontSizeToFitWidth = true
        nameLab.textColor = Colors.cellTitleGray
        return nameLab
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
