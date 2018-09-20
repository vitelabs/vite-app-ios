//
//  CreateWalletTipViewController.swift
//  Vite
//
//  Created by Water on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Vite_keystore

class CreateWalletTipViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var tipTitleLab: UILabel = {
        let tipTitleLab = UILabel()
        tipTitleLab.textAlignment = .left
        tipTitleLab.numberOfLines = 0
        tipTitleLab.font = Fonts.descFont
        tipTitleLab.textColor  = Colors.titleGray
        tipTitleLab.text =  R.string.localizable.createPageTipContent.key.localized()
        return tipTitleLab
    }()

    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton.init(style: .blue)
        nextBtn.setTitle(R.string.localizable.createPageTipNextBtn.key.localized(), for: .normal)
        nextBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        return nextBtn
    }()
}

extension CreateWalletTipViewController {
    func _setupView() {
        self.view.backgroundColor = .white
        navigationTitleView = NavigationTitleView(title: R.string.localizable.createPageTipTitle.key.localized())

        self._addViewConstraint()
    }

    func _addViewConstraint() {
        let iconImgView = UIImageView.init(image: R.image.beifen())
        self.view.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(30)
        }

        self.view.addSubview(self.tipTitleLab)
        self.tipTitleLab.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(56)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
        }

        self.view.addSubview(self.nextBtn)
        self.nextBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }
    }

    @objc func nextBtnAction() {
        let backupMnemonicCashVC = BackupMnemonicViewController()
        self.navigationController?.pushViewController(backupMnemonicCashVC, animated: true)
    }
}
