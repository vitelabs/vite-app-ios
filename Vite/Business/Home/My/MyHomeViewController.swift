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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white

        form +++
             Section {section in
                var header = HeaderFooterView<MyHomeListHeaderView>(.class)

                header = HeaderFooterView<MyHomeListHeaderView>(.class)
                header.onSetupView = { view, section in
                    view.delegate = self
                }
                header.height = { 130.0 }
                section.header = header
             }

            <<< ImageRow("my.page.message.cell.title") {
                $0.cell.titleLab.text = R.string.localizable.myPageMessageCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }.onCellSelection({ [unowned self] _, _  in
                    let safari = SFSafariViewController(url: NSURL(string: "http://www.baidu.com")! as URL)
                    self.present(safari, animated: true, completion: nil)
            })

            <<< ImageRow("my.page.system.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageSystemCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }.onCellSelection({ [unowned self] _, _  in
                let vc = SystemViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })

            <<< ImageRow("my.page.help.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageHelpCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }
            <<< ImageRow("my.page.aboutUs.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageAboutUsCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }
            <<< ImageRow("my.page.fetchMoney.cell.title") {
                $0.cell.titleLab.text =  R.string.localizable.myPageFetchMoneyCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }
    }
}

extension MyHomeViewController: MyHomeListHeaderViewDelegate {
    func transactionLogBtnAction() {
        let address = Address(string: WalletDataService.shareInstance.walletStorage.walletAccounts[0].defaultKey.address)
        navigationController?.pushViewController(TransactionListViewController(address: address), animated: true)
    }

    func manageWalletBtnAction() {
        let vc = ManageWalletViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
