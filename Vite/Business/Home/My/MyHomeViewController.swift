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
                    m.top.equalTo(view.safeAreaLayoutGuideSnpTop)
                    m.left.equalTo(view)
                    m.right.equalTo(view)
                }
            }
        }
    }

    let isOpenFetchGift = UserDefaults.standard.bool(forKey: UserDefaultsName.isOpenFetchGift)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarStyle.configStyle(navigationBarStyle, viewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitleView = NavigationTitleView(title: R.string.localizable.myPageTitle())
        self.view.backgroundColor = .white

        self.setupTableView()
    }

    func setupTableView() {
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none

        ImageRow.defaultCellSetup = { cell, row in
            cell.selectionStyle = .none
        }

        form +++
            Section {section in
                var header = HeaderFooterView<MyHomeListHeaderView>(.class)
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
                $0.cell.rightImageView.image = R.image.icon_token_vite()
            }.onCellSelection({ [unowned self] _, _  in
                let vc = AboutUsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })

            <<< ImageRow("my.page.fetchMoney.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageFetchMoneyCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.gift()
                $0.hidden = showFetchMoneyCondition
            }.onCellSelection({ [unowned self] _, _  in
                    let vc = FetchWelfareViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!).offset(-20)
            make.left.right.bottom.equalTo(self.view)
        }
    }

    private var showFetchMoneyCondition: Condition {
       return Eureka.Condition.function([], {[weak self] _ in
            return self?.isOpenFetchGift == false
        })
    }
}

extension MyHomeViewController: MyHomeListHeaderViewDelegate {
    func transactionLogBtnAction() {
        navigationController?.pushViewController(TransactionListViewController(), animated: true)
    }

    func manageWalletBtnAction() {
        let vc = ManageWalletViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
