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
import Vite_HDWalletKit

class AffirmInputMnemonicViewController: BaseViewController, MnemonicCollectionViewDelegate {
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
        let submitBtn = UIButton.init(style: .blue)
        submitBtn.setTitle(R.string.localizable.finish.key.localized(), for: .normal)
        submitBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
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
        let backItem = UIBarButtonItem(image: R.image.icon_nav_back_black(), style: .plain, target: self, action: #selector(backItemAction))
        navigationItem.leftBarButtonItem = backItem

        navigationTitleView = NavigationTitleView(title: R.string.localizable.mnemonicAffirmPageTitle.key.localized())
        self._addViewConstraint()
    }

    func _addViewConstraint() {
        self.view.addSubview(self.tipTitleLab)
        self.tipTitleLab.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!).offset(10)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(24)
        }

        self.view.addSubview(self.chooseMnemonicCollectionView)
        self.chooseMnemonicCollectionView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.tipTitleLab.snp.bottom).offset(18)
            make.height.equalTo(kScreenH * (186.0/667.0))
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
        }

        self.view.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }

        self.view.addSubview(self.defaultMnemonicCollectionView)
        self.defaultMnemonicCollectionView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.chooseMnemonicCollectionView.snp.bottom).offset(12)
            make.height.lessThanOrEqualTo(kScreenH * (210.0/667.0))
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.bottom.equalTo(self.submitBtn.snp.top).offset(-10).priority(250)
        }
    }

    @objc func submitBtnAction() {
        let chooseStr = self.viewModel.hasChooseMnemonicWordsList.value.joined(separator: " ")
        if chooseStr != CreateWalletService.sharedInstance.mnemonic {
            self.displayConfirmAlter(title: R.string.localizable.mnemonicAffirmAlterCheckTitle.key.localized(), done: R.string.localizable.confirm.key.localized(), doneHandler: {

            })
        } else {
            self.view.displayLoading(text: R.string.localizable.mnemonicAffirmPageAddLoading.key.localized(), animated: true)
            DispatchQueue.global().async {
                let uuid = UUID().uuidString
                let encryptKey = CreateWalletService.sharedInstance.password.toEncryptKey(salt: uuid)
                KeychainService.instance.setCurrentWallet(uuid: uuid, encryptKey: encryptKey)
                HDWalletManager.instance.addAddLoginWallet(uuid: uuid, name: CreateWalletService.sharedInstance.name, mnemonic: CreateWalletService.sharedInstance.mnemonic, encryptKey: encryptKey)
                DispatchQueue.main.async {
                    self.view.hideLoading()
                    NotificationCenter.default.post(name: .createAccountSuccess, object: nil)
                }
            }
        }
    }

    @objc func backItemAction() {
        self.displayAlter(title: R.string.localizable.mnemonicAffirmAlterTitle.key.localized(), message: "", cancel: R.string.localizable.no.key.localized(), done:
            R.string.localizable.yes.key.localized(),
                          doneHandler: {
                self.navigationController?.popViewController(animated: true)
        })
    }
}
