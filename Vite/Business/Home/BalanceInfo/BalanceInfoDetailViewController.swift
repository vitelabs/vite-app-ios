//
//  BalanceInfoDetailViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

class BalanceInfoDetailViewController: BaseViewController {

    let viewModelBehaviorRelay: BehaviorRelay<WalletHomeBalanceInfoViewModelType>

    init(viewModel: WalletHomeBalanceInfoViewModelType) {
        self.viewModelBehaviorRelay = BehaviorRelay(value: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    fileprivate func setupView() {
        let detailView = BalanceInfoDetailView()
        let showTransactionsButton = UIButton.init(type: .system).then {
            $0.setTitleColor(UIColor.red, for: .normal)
            $0.setTitle(R.string.localizable.balanceInfoDetailShowTransactionsButtonTitle(), for: .normal)
        }
        let receiveButton = UIButton.init(type: .system).then {
            $0.setTitleColor(UIColor.red, for: .normal)
            $0.backgroundColor = UIColor.blue
            $0.setTitle(R.string.localizable.balanceInfoDetailReveiceButtonTitle(), for: .normal)
        }
        let sendButton = UIButton.init(type: .system).then {
            $0.setTitleColor(UIColor.red, for: .normal)
            $0.backgroundColor = UIColor.yellow
            $0.setTitle(R.string.localizable.balanceInfoDetailSendButtonTitle(), for: .normal)
        }

        view.addSubview(detailView)
        view.addSubview(showTransactionsButton)
        view.addSubview(receiveButton)
        view.addSubview(sendButton)

        detailView.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuideSnp.top)
            m.left.right.equalTo(view)
        }

        showTransactionsButton.snp.makeConstraints { (m) in
            m.top.equalTo(detailView.snp.bottom).offset(15)
            m.centerX.equalTo(view)
        }

        receiveButton.snp.makeConstraints { (m) in
            m.left.equalTo(view)
            m.bottom.equalTo(view.safeAreaLayoutGuideSnp.bottom)
        }

        sendButton.snp.makeConstraints { (m) in
            m.left.equalTo(receiveButton.snp.right)
            m.right.equalTo(view)
            m.width.equalTo(receiveButton)
            m.bottom.equalTo(receiveButton)
        }

        showTransactionsButton.rx.tap.bind { [weak self] in
            let address = Address(string: (WalletDataService.shareInstance.defaultWalletAccount?.defaultKey.address)!)
            self?.navigationController?.pushViewController(TransactionListViewController(address: address), animated: true)
        }.disposed(by: rx.disposeBag)

        receiveButton.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(ReceiveViewController(), animated: true)
        }.disposed(by: rx.disposeBag)

        sendButton.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(SendViewController(), animated: true)
        }.disposed(by: rx.disposeBag)

        detailView.bind(viewModelBehaviorRelay: viewModelBehaviorRelay)
        viewModelBehaviorRelay.asObservable().map { $0.name }.bind(to: navigationItem.rx.title).disposed(by: rx.disposeBag)
    }
}
