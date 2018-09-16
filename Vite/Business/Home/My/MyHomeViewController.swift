//
//  MyHomeViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Eureka
import SafariServices

class MyHomeViewController: FormViewController {
    var navigationBarStyle = NavigationBarStyle.clear
    var navigationTitleView: NavigationTitleView? {
        didSet {
            if let old = oldValue {
                old.removeFromSuperview()
            }

            if let new = navigationTitleView {
                view.addSubview(new)
                new.snp.makeConstraints { (m) in
                    m.top.equalTo(view.safeAreaLayoutGuideSnp.top)
                    m.left.equalTo(view)
                    m.right.equalTo(view)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarStyle.configStyle(navigationBarStyle, viewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitleView = NavigationTitleView(title: "我")
        self.view.backgroundColor = .white

        self.setupTableView()
    }

    func setupTableView() {
        self.tableView.backgroundColor = .white

        form +++
            Section {section in
                var header = HeaderFooterView<MyHomeListHeaderView>(.class)

                header = HeaderFooterView<MyHomeListHeaderView>(.class)
                header.onSetupView = { view, section in
                    view.delegate = self
                }
                header.height = { 100.0 }
                section.header = header
            }

            <<< ImageRow("my.page.system.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageSystemCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.icon_setting()
            }.onCellSelection({ [unowned self] _, _  in
                    let vc = SystemViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
            })

            <<< ImageRow("my.page.aboutUs.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageAboutUsCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.splash_about()
            }.onCellSelection({ [unowned self] _, _  in
                    let safari = SFSafariViewController(url: NSURL(string: "https://www.vite.org/zh/")! as URL)
                    self.present(safari, animated: true, completion: nil)
            })

            <<< ImageRow("my.page.fetchMoney.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageFetchMoneyCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.gift()
            }.onCellSelection({ [unowned self] _, _  in
                    let safari = SFSafariViewController(url: NSURL(string: "https://www.vite.org/zh/")! as URL)
                    self.present(safari, animated: true, completion: nil)
            })

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}

extension MyHomeViewController: MyHomeListHeaderViewDelegate {
    func transactionLogBtnAction() {
        let address = Address(string: (WalletDataService.shareInstance.defaultWalletAccount?.defaultKey.address)!)
        navigationController?.pushViewController(TransactionListViewController(address: address), animated: true)
    }

    func manageWalletBtnAction() {
        let vc = ManageWalletViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
