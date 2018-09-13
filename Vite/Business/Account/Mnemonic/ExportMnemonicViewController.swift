//
//  ExportMnemonicViewController.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Vite_keystore

class ExportMnemonicViewController: BaseViewController {
    fileprivate var viewModel: BackupMnemonicVM

    init() {
        self.viewModel = BackupMnemonicVM()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
        self._bindViewModel()
    }

    lazy var tipContentTitleLab: UILabel = {
        let tipContentTitleLab = UILabel()
        tipContentTitleLab.textAlignment = .left
        tipContentTitleLab.font =  AppStyle.descWord.font
        tipContentTitleLab.textColor  = AppStyle.descWord.textColor
        tipContentTitleLab.text =  R.string.localizable.mnemonicBackupPageTitle.key.localized()
        return tipContentTitleLab
    }()

    lazy var tipContentLab: UILabel = {
        let tipContentLab =  UILabel()
        tipContentLab.numberOfLines = 0
        tipContentLab.textColor = .black
        return tipContentLab
    }()

    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton()
        confirmBtn.setTitle(R.string.localizable.mnemonicBackupPageTipNextBtnTitle.key.localized(), for: .normal)
        confirmBtn.setTitleColor(.black, for: .normal)
        confirmBtn.backgroundColor = .orange
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return confirmBtn
    }()
}

extension ExportMnemonicViewController {
    private func _bindViewModel() {
        _ = self.viewModel.mnemonicWordsStr.asObservable().bind(to: self.tipContentLab.rx.text)
    }

    private func _setupView() {
        self.view.backgroundColor = .white
        self.title = R.string.localizable.mnemonicBackupPageTitle.key.localized()

        self._addViewConstraint()
    }
    private func _addViewConstraint() {

        self.view.addSubview(self.tipContentTitleLab)
        self.tipContentTitleLab.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.view).offset(30)
        }

        self.view.addSubview(self.tipContentLab)
        self.tipContentLab.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.tipContentTitleLab.snp.bottom).offset(10)
        }

        self.view.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(130)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-100)
        }
    }

    @objc func confirmBtnAction() {
        CreateWalletService.sharedInstance.walletAccount.mnemonic = self.viewModel.mnemonicWordsStr.value
        let vc = AffirmInputMnemonicViewController.init(mnemonicWordsStr: self.viewModel.mnemonicWordsStr.value)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
