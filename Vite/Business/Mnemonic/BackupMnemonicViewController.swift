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

    lazy var afreshMnemonicBtn: UIButton = {
        let afreshMnemonicBtn = UIButton()
        afreshMnemonicBtn.setTitle("重新生成助记词", for: .normal)
        afreshMnemonicBtn.setTitleColor(.black, for: .normal)
        afreshMnemonicBtn.backgroundColor = .orange
        afreshMnemonicBtn.addTarget(self, action: #selector(afreshMnemonicBtnAction), for: .touchUpInside)
        return afreshMnemonicBtn
    }()

    lazy var nextMnemonicBtn: UIButton = {
        let nextMnemonicBtn = UIButton()
        nextMnemonicBtn.setTitle("助记词已备份", for: .normal)
        nextMnemonicBtn.setTitleColor(.black, for: .normal)
        nextMnemonicBtn.backgroundColor = .orange
        nextMnemonicBtn.addTarget(self, action: #selector(nextMnemonicBtnAction), for: .touchUpInside)
        return nextMnemonicBtn
    }()

    lazy var tipLab: UILabel = {
       let tipLab =  UILabel()
        tipLab.text = self.wordList
        tipLab.numberOfLines = 0
        tipLab.textColor = .black
        return tipLab
    }()

    lazy var wordList: String = {
        var wordList =  String()
        wordList =  Mnemonic.randomGenerator(strength: .strong, language: .english)
        return wordList
    }()

    init() {
        self.viewModel = BackupMnemonicVM.init()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupView()
        self._bindViewModel()

        self.title = "备份钱包助记词"
    }

    private func _bindViewModel() {

    }

    private func _setupView() {
        self.view.backgroundColor = .white

        self._addViewConstraint()
    }
    private func _addViewConstraint() {
        self.view.backgroundColor = .white
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

        self.view.addSubview(self.tipLab)
        self.tipLab.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(100)
        }
    }

    @objc func afreshMnemonicBtnAction() {
        wordList = Mnemonic.randomGenerator(strength: .strong, language: .english)
        tipLab.text = wordList
    }

    @objc func nextMnemonicBtnAction() {

    }
}
