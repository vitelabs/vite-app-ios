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

        self.addSubview(self.nameTextField)
        self.addSubview(self.rightImageView)
        self.rightImageView.snp.makeConstraints {  (make) -> Void in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self.nameTextField)
        }

        self.nameTextField.snp.makeConstraints {  (make) -> Void in
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
    }

    lazy var nameTitleLab: UILabel = {
        let nameTitleLab =  UILabel()
        nameTitleLab.text = R.string.localizable.manageWalletPageNameCellTitle()
        nameTitleLab.textAlignment = .left
        nameTitleLab.textColor =  Colors.titleGray
        nameTitleLab.adjustsFontSizeToFitWidth = true
        nameTitleLab.font = Fonts.light14
        return nameTitleLab
    }()

    lazy var nameTextField: UITextField = {
        let nameTextField =  UITextField()
        nameTextField.text = HDWalletManager.instance.wallet?.name
        nameTextField.textAlignment = .left
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.textColor = Colors.cellTitleGray
        nameTextField.font = Fonts.light16
        nameTextField.returnKeyType = .done
        return nameTextField
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

}
