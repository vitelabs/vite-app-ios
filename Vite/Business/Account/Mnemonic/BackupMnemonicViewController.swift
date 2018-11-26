//
//  BackupMnemonicViewController.swift
//  Vite
//
//  Created by Water on 2018/9/4.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Vite_HDWalletKit

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // other page inter then refresh words
        self.viewModel.fetchNewMnemonicWordsAction?.execute(())
    }

    lazy var tipTitleLab: UILabel = {
        let tipTitleLab = UILabel()
        tipTitleLab.textAlignment = .left
        tipTitleLab.numberOfLines = 0
        tipTitleLab.adjustsFontSizeToFitWidth = true
        tipTitleLab.font = Fonts.descFont
        tipTitleLab.textColor  = Colors.titleGray
        tipTitleLab.text =  R.string.localizable.mnemonicBackupPageTipTitle()
        return tipTitleLab
    }()

    lazy var switchTipView: LabelTipView = {
        let switchTipView = LabelTipView(R.string.localizable.mnemonicBackupPageSwitchModeTitle("12"))
        switchTipView.titleLab.font = Fonts.Font12
        switchTipView.titleLab.textColor = UIColor(netHex: 0x007AFF)
        switchTipView.tipButton.setImage(R.image.switch_mode_icon(), for: .normal)
        switchTipView.tipButton.setImage(R.image.switch_mode_icon(), for: .highlighted)
        switchTipView.rx.tap.bind {
            self.viewModel.switchModeMnemonicWordsAction?.execute(())
        }.disposed(by: rx.disposeBag)
        switchTipView.tipButton.rx.tap.bind {
            self.viewModel.switchModeMnemonicWordsAction?.execute(())
        }.disposed(by: rx.disposeBag)
        return switchTipView
    }()

    lazy var mnemonicCollectionView: MnemonicCollectionView = {
        let mnemonicCollectionView = MnemonicCollectionView.init(isHasSelected: true)
        return mnemonicCollectionView
    }()

    lazy var afreshMnemonicBtn: UIButton = {
        let afreshMnemonicBtn = UIButton.init(style: .white)
    afreshMnemonicBtn.setTitle(R.string.localizable.mnemonicBackupPageTipAnewBtnTitle(), for: .normal)
        afreshMnemonicBtn.rx.tap.bind {
                    self.viewModel.fetchNewMnemonicWordsAction?.execute(())
        }.disposed(by: rx.disposeBag)
        return afreshMnemonicBtn
    }()

    lazy var nextMnemonicBtn: UIButton = {
        let nextMnemonicBtn = UIButton.init(style: .blue)
        nextMnemonicBtn.setTitle(R.string.localizable.mnemonicBackupPageTipNextBtnTitle(), for: .normal)
        nextMnemonicBtn.addTarget(self, action: #selector(nextMnemonicBtnAction), for: .touchUpInside)
        return nextMnemonicBtn
    }()

    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
}

extension BackupMnemonicViewController {
    private func _bindViewModel() {
        self.viewModel.mnemonicWordsList.asObservable().subscribe { (_) in
            if self.viewModel.mnemonicWordsList.value.count == 12 {
                self.switchTipView.titleLab.text = R.string.localizable.mnemonicBackupPageSwitchModeTitle("24")
                self.mnemonicCollectionView.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(kScreenH * (96.0/667.0))
                }
                self.mnemonicCollectionView.h_num =  CGFloat(3.0)
            } else {
                self.switchTipView.titleLab.text = R.string.localizable.mnemonicBackupPageSwitchModeTitle("12")
                self.mnemonicCollectionView.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(kScreenH * (186.0/667.0))
                }
                self.mnemonicCollectionView.h_num =  CGFloat(6.0)
            }

            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.layoutIfNeeded()
            })

            self.mnemonicCollectionView.dataList = (self.viewModel.mnemonicWordsList.value)
        }.disposed(by: rx.disposeBag)

        NotificationCenter.default.rx
            .notification(NSNotification.Name.UIApplicationUserDidTakeScreenshot)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                Alert.show(title: R.string.localizable.mnemonicBackupPageAlterTitle(), message: R.string.localizable.mnemonicBackupPageAlterMessage(), actions: [
                    (.default(title: R.string.localizable.mnemonicBackupPageAlterCancel()), nil),
                    (.default(title: R.string.localizable.mnemonicBackupPageAlterConfirm()), { _ in
                        self.viewModel.fetchNewMnemonicWordsAction?.execute(())
                    }),
                    ])
            }).disposed(by: rx.disposeBag)
    }

    private func _setupView() {
        self.view.backgroundColor = .white
        navigationTitleView = NavigationTitleView(title: R.string.localizable.mnemonicBackupPageTitle())

        self._addViewConstraint()
    }
    private func _addViewConstraint() {
        self.view.addSubview(self.tipTitleLab)
        self.tipTitleLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(24+32)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(48)
        }
        self.view.addSubview(self.afreshMnemonicBtn)
        self.afreshMnemonicBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }

        self.view.addSubview(self.nextMnemonicBtn)
        self.nextMnemonicBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.afreshMnemonicBtn.snp.top).offset(-24)
        }

        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(self.tipTitleLab.snp.bottom)
            make.bottom.equalTo(self.nextMnemonicBtn.snp.top)
        }

        contentView.addSubview(self.mnemonicCollectionView)
        self.mnemonicCollectionView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.centerY.equalTo(contentView)
            make.height.equalTo(kScreenH * (186.0/667.0))
        }
        contentView.addSubview(self.switchTipView)
        self.switchTipView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.mnemonicCollectionView.snp.top).offset(-10)
            make.right.equalTo(self.mnemonicCollectionView)
            make.height.equalTo(20)
        }
    }

    @objc func nextMnemonicBtnAction() {
        CreateWalletService.sharedInstance.mnemonic = self.viewModel.mnemonicWordsStr.value
        let vc = AffirmInputMnemonicViewController.init(mnemonicWordsStr: self.viewModel.mnemonicWordsStr.value)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
