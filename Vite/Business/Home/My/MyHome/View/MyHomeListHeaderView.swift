//
//  MyHomeListHeaderView.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

protocol MyHomeListHeaderViewDelegate: class {
    func transactionLogBtnAction()
    func manageWalletBtnAction()
    func manageQuotaBtnAction()
}

class MyHomeListHeaderView: UIView {

    weak var delegate: MyHomeListHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let margin = kScreenW == 320 ? 18 : 24
        self.addSubview(self.manageWalletBtn)
        self.manageWalletBtn.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(margin)
            make.top.equalTo(self).offset(32)
            make.height.equalTo(84)
            make.width.equalTo(100)
        }

        self.addSubview(transactionLogBtn)
        self.transactionLogBtn.snp.makeConstraints {  (make) -> Void in
            make.top.equalTo(self).offset(32)
            make.height.equalTo(84)
            make.width.equalTo(100)
            make.centerX.equalTo(self)
        }

        self.addSubview(manageQuotaBtn)
        self.manageQuotaBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(32)
            make.height.equalTo(84)
            make.right.equalTo(self).offset(-margin)
            make.width.equalTo(100)
        }
    }

    lazy var manageWalletBtn: IconBtnView = {
        let manageWalletBtn = IconBtnView.init(iconImg: R.image.icon_wallet()!, text: R.string.localizable.myPageMangeWalletCellTitle.key.localized())
        manageWalletBtn.btn.addTarget(self, action: #selector(manageWalletBtnAction), for: .touchUpInside)
        return manageWalletBtn
    }()

    lazy var transactionLogBtn: IconBtnView = {
        let transactionLogBtn = IconBtnView.init(iconImg: R.image.icon_transrecord()!, text: R.string.localizable.myPageDealLogCellTitle.key.localized())
        transactionLogBtn.btn.addTarget(self, action: #selector(transactionLogBtnAction), for: .touchUpInside)
        return transactionLogBtn
    }()

    lazy var manageQuotaBtn: IconBtnView = {
        let manageQuotaBtn = IconBtnView.init(iconImg: R.image.icon_quota()!, text: R.string.localizable.myPageQuotaCellTitle.key.localized())
        manageQuotaBtn.btn.addTarget(self, action: #selector(manageQuotaBtnAction), for: .touchUpInside)
        return manageQuotaBtn
    }()

    @objc func transactionLogBtnAction() {
        self.delegate?.transactionLogBtnAction()
    }

    @objc func manageWalletBtnAction() {
        self.delegate?.manageWalletBtnAction()
    }

    @objc func manageQuotaBtnAction() {
        self.delegate?.manageQuotaBtnAction()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
