//
//  AffirmInputMnemonicViewController.swift
//  Vite
//
//  Created by Water on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxDataSources
import Vite_keystore

class AffirmInputMnemonicViewController: UIViewController, MnemonicCollectionViewDelegate {
    fileprivate var viewModel: AffirmInputMnemonicVM

    init(mnemonicWordsStr: String) {
        self.viewModel = AffirmInputMnemonicVM.init(mnemonicWordsStr: mnemonicWordsStr)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    init() {
        fatalError("init has not been implemented")
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

    lazy var chooseMnemonicCollectionView: MnemonicCollectionView = {
        let chooseMnemonicCollectionView = MnemonicCollectionView.init(isHasSelected: true)
        chooseMnemonicCollectionView.delegate = self
        chooseMnemonicCollectionView.backgroundColor = .orange
        return chooseMnemonicCollectionView
    }()

    lazy var defaultMnemonicCollectionView: MnemonicCollectionView = {
        let defaultMnemonicCollectionView = MnemonicCollectionView.init(isHasSelected: false)
        defaultMnemonicCollectionView.delegate = self
        defaultMnemonicCollectionView.backgroundColor = .red
        return defaultMnemonicCollectionView
    }()

    func chooseWord(isHasSelected: Bool, dataIndex: Int, word: String) {
        self.viewModel.selectedWord(isHasSelected: isHasSelected, dataIndex: dataIndex, word: word)
    }
}

extension AffirmInputMnemonicViewController {
    private func _bindViewModel() {
        self.viewModel.hasChooseMnemonicWordsList.asObservable().subscribe { (_) in
            self.chooseMnemonicCollectionView.dataList = (self.viewModel.hasChooseMnemonicWordsList.value)
        }.disposed(by: rx.disposeBag)

        self.viewModel.hasLeftMnemonicWordsList.asObservable().subscribe { (_) in
            self.defaultMnemonicCollectionView.dataList = (self.viewModel.hasLeftMnemonicWordsList.value)
        }.disposed(by: rx.disposeBag)
    }

    private func _setupView() {
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

        self.view.addSubview(self.chooseMnemonicCollectionView)
        self.chooseMnemonicCollectionView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.tipTitleLab.snp.bottom).offset(20)
            make.height.equalTo(140)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
        }

        self.view.addSubview(self.defaultMnemonicCollectionView)
        self.defaultMnemonicCollectionView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.chooseMnemonicCollectionView.snp.bottom).offset(30)
            make.height.equalTo(140)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
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
        let walletAccount = CreateWalletService.sharedInstance.walletAccount

       WalletDataService.shareInstance.addWallet(account: walletAccount)
        WalletDataService.shareInstance.loginWallet(account: walletAccount)
        NotificationCenter.default.post(name: .createAccountSuccess, object: nil)
    }
}
