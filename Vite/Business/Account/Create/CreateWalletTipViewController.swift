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

class CreateWalletTipViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var tipTitleLab: UILabel = {
        let tipTitleLab = UILabel()
        tipTitleLab.textAlignment = .center
        tipTitleLab.numberOfLines = 0
        tipTitleLab.font =  AppStyle.descWord.font
        tipTitleLab.textColor  = AppStyle.descWord.textColor
        tipTitleLab.text =  R.string.localizable.createPageTipContent.key.localized()
        return tipTitleLab
    }()

    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton()
        nextBtn.setTitle(R.string.localizable.createPageTipNextBtn.key.localized(), for: .normal)
        nextBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.backgroundColor = .orange
        nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        return nextBtn
    }()
}

extension CreateWalletTipViewController {
    func _setupView() {
        self.view.backgroundColor = .white
        self.title = R.string.localizable.createPageTipTitle.key.localized()

        self._addViewConstraint()
    }

    func _addViewConstraint() {
        self.view.addSubview(self.tipTitleLab)
        self.tipTitleLab.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-100)
            make.left.equalTo(self.view).offset(60)
            make.right.equalTo(self.view).offset(-60)
            make.height.equalTo(120)
        }

        self.view.addSubview(self.nextBtn)
        self.nextBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(45)
            make.bottom.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
        }
    }

    @objc func nextBtnAction() {
        let backupMnemonicCashVC = BackupMnemonicViewController()
        self.navigationController?.pushViewController(backupMnemonicCashVC, animated: true)
    }
}
