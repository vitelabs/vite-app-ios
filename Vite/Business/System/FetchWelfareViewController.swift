//
//  FetchWelfareViewController.swift
//  Vite
//
//  Created by Water on 2018/9/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import UIKit
import SnapKit
import Vite_keystore

class FetchWelfareViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var contentTextView: UITextView = {
        let contentTextView =  UITextView()
        contentTextView.font = Fonts.Font18
        contentTextView.backgroundColor = Colors.bgGray
        contentTextView.textColor = Colors.descGray
        contentTextView.text = WalletDataService.shareInstance.defaultWalletAccount?.mnemonic
        contentTextView.layer.masksToBounds = true
        contentTextView.layer.cornerRadius = 2
        contentTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        return contentTextView
    }()

    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton.init(style: .blue)
        confirmBtn.setTitle(R.string.localizable.confirm.key.localized(), for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return confirmBtn
    }()
}

extension FetchWelfareViewController {

    private func _setupView() {
        self.view.backgroundColor = .white
        navigationTitleView = NavigationTitleView(title: R.string.localizable.exportPageTitle.key.localized())

        self._addViewConstraint()
    }
    private func _addViewConstraint() {
        self.view.addSubview(self.contentTextView)
        self.contentTextView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(142)
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!).offset(10)
        }

        self.view.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnp.bottom).offset(-24)
        }
    }

    @objc func confirmBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
