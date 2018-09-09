//
//  BackupMnemonicViewController.swift
//  Vite
//
//  Created by Water on 2018/9/4.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Vite_keystore

class BackupMnemonicViewController: BaseViewController {
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

    lazy var tipTitleLab: UILabel = {
        let tipTitleLab = UILabel()
        tipTitleLab.textAlignment = .center
        tipTitleLab.numberOfLines = 0
        tipTitleLab.font =  AppStyle.descWord.font
        tipTitleLab.textColor  = AppStyle.descWord.textColor
        tipTitleLab.text =  R.string.localizable.mnemonicBackupPageTipTitle.key.localized()
        return tipTitleLab
    }()

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

    lazy var afreshMnemonicBtn: UIButton = {
        let afreshMnemonicBtn = UIButton()

        afreshMnemonicBtn.setTitle(R.string.localizable.mnemonicBackupPageTipAnewBtnTitle.key.localized(), for: .normal)
        afreshMnemonicBtn.setTitleColor(.black, for: .normal)
        afreshMnemonicBtn.backgroundColor = .orange
        afreshMnemonicBtn.addTarget(self, action: #selector(afreshMnemonicBtnAction), for: .touchUpInside)
        return afreshMnemonicBtn
    }()

    lazy var nextMnemonicBtn: UIButton = {
        let nextMnemonicBtn = UIButton()
        nextMnemonicBtn.setTitle(R.string.localizable.mnemonicBackupPageTipNextBtnTitle.key.localized(), for: .normal)
        nextMnemonicBtn.setTitleColor(.black, for: .normal)
        nextMnemonicBtn.backgroundColor = .orange
        nextMnemonicBtn.addTarget(self, action: #selector(nextMnemonicBtnAction), for: .touchUpInside)
        return nextMnemonicBtn
    }()
}

extension BackupMnemonicViewController {
    private func _bindViewModel() {
        _ = self.viewModel.mnemonicWordsStr.asObservable().bind(to: self.tipContentLab.rx.text)
    }

    private func _setupView() {
        self.view.backgroundColor = .white
        self.title = R.string.localizable.mnemonicBackupPageTitle.key.localized()

        self._addViewConstraint()
    }
    private func _addViewConstraint() {
        self.view.addSubview(self.tipTitleLab)
        self.tipTitleLab.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(80)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(30+64)
        }

        self.view.addSubview(self.tipContentTitleLab)
        self.tipContentTitleLab.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.tipTitleLab.snp.bottom).offset(30)
        }

        self.view.addSubview(self.tipContentLab)
        self.tipContentLab.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.tipContentTitleLab.snp.bottom).offset(10)
        }

        self.view.addSubview(self.afreshMnemonicBtn)
        self.afreshMnemonicBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(130)
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(30)
            make.bottom.equalTo(self.view).offset(-100)
        }

        self.view.addSubview(self.nextMnemonicBtn)
        self.nextMnemonicBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(130)
            make.height.equalTo(50)
            make.right.equalTo(self.view).offset(-30)
            make.bottom.equalTo(self.view).offset(-100)
        }
    }

    @objc func afreshMnemonicBtnAction() {
        _ = self.viewModel.fetchNewMnemonicWords()
    }

    @objc func nextMnemonicBtnAction() {
        let vc = AffirmInputMnemonicViewController.init(mnemonicWordsStr: self.viewModel.mnemonicWordsStr.value)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
