//
//  ManageWalletViewController.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Eureka
import SafariServices

class ManageWalletViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.localizable.manageWalletPageTitle.key.localized()
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white

        form +++
            Section {
                $0.header = HeaderFooterView<ManageWalletHeaderView>(.class)
                $0.header?.height = { 100.0 }
            }
            <<< ImageRow("manageWalletPageNameCellTitle") {
                $0.cell.titleLab.text = R.string.localizable.manageWalletPageNameCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }.onCellSelection({ [unowned self] _, _  in
                let safari = SFSafariViewController(url: NSURL(string: "http://www.baidu.com")! as URL)
                self.present(safari, animated: true, completion: nil)
            })

            <<< ImageRow("manageWalletPageAddressManageCellTitle") {
                $0.cell.titleLab.text =  R.string.localizable.manageWalletPageAddressManageCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }.onCellSelection({ [unowned self] _, _  in
                let vc = AddressManageViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })

            <<< ImageRow("manageWalletPageImportMnemonicCellTitle") {
                $0.cell.titleLab.text =  R.string.localizable.manageWalletPageImportMnemonicCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.bar_icon_my()
            }.onCellSelection({ [unowned self] _, _  in
                let vc = ExportMnemonicViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
    }
}
