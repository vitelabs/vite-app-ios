//
//  ManageWalletHeaderView.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

protocol ManageWalletHeaderViewDelegate: class {
    func changeNameAction()
}

class ManageWalletHeaderView: UIView {
    weak var delegate: ManageWalletHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.nameTitleLab)
        self.nameTitleLab.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(24)
            make.top.equalTo(self)
            make.height.equalTo(20)
        }

        self.addSubview(self.nameLab)
        self.addSubview(self.rightImageView)
        self.rightImageView.snp.makeConstraints {  (make) -> Void in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self.nameLab)
        }

        self.nameLab.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-50)
            make.bottom.equalTo(self).offset(-19)
            make.height.equalTo(20)
        }

        self.addSubview(lineView)
        lineView.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24)
            make.bottom.equalTo(self).offset(-1)
            make.height.equalTo(CGFloat.singleLineWidth)
        }

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapAction))
        self.addGestureRecognizer(gesture)
    }

    lazy var nameTitleLab: UILabel = {
        let nameTitleLab =  UILabel()
        nameTitleLab.text = R.string.localizable.manageWalletPageNameCellTitle.key.localized()
        nameTitleLab.textAlignment = .left
        nameTitleLab.textColor =  Colors.titleGray
        nameTitleLab.adjustsFontSizeToFitWidth = true
        nameTitleLab.font = Fonts.light14
        return nameTitleLab
    }()

    lazy var nameLab: UILabel = {
        let nameLab =  UILabel()
        nameLab.text = WalletDataService.shareInstance.defaultWalletAccount?.name
        nameLab.textAlignment = .left
        nameLab.adjustsFontSizeToFitWidth = true
        nameLab.textColor = Colors.cellTitleGray
        nameLab.font = Fonts.light16
        return nameLab
    }()

    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView.init(image: R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable)
        rightImageView.backgroundColor = .clear
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.contentMode = .scaleAspectFit
        return rightImageView
    }()

    lazy var lineView: LineView = {
        let lineView = LineView.init(direction: .horizontal)
        lineView.backgroundColor = Colors.lineGray
        lineView.alpha = 1.0
        return lineView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapAction() {
        self.delegate?.changeNameAction()
    }
}
