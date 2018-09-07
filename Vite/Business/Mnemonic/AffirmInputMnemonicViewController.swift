//
//  AffirmInputMnemonicViewController.swift
//  Vite
//
//  Created by Water on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class AffirmInputMnemonicViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var tipTitleLab: UILabel = {
        let tipTitleLab = UILabel()
        tipTitleLab.textAlignment = .left
        tipTitleLab.font =  AppStyle.descWord.font
        tipTitleLab.textColor  = AppStyle.descWord.textColor
        tipTitleLab.text =  R.string.localizable.mnemonicAffirmPageTipTitle.key.localized()
        return tipTitleLab
    }()

    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton()
        submitBtn.setTitle(R.string.localizable.finish.key.localized(), for: .normal)
        submitBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        submitBtn.setTitleColor(.black, for: .normal)
        submitBtn.backgroundColor = .orange
        submitBtn.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        return submitBtn
    }()
}

extension AffirmInputMnemonicViewController {
    func _setupView() {
        self.view.backgroundColor = .white
        self.title = R.string.localizable.mnemonicAffirmPageTitle.key.localized()

        self._addViewConstraint()
    }

    func _addViewConstraint() {
        self.view.addSubview(self.tipTitleLab)
        self.tipTitleLab.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(100)
            make.left.equalTo(self.view).offset(30)
            make.height.equalTo(30)
        }

        self.view.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(45)
            make.bottom.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
        }
    }

    @objc func submitBtnAction() {
        let backupMnemonicCashVC = BackupMnemonicViewController()
        self.navigationController?.pushViewController(backupMnemonicCashVC, animated: true)
    }
}
