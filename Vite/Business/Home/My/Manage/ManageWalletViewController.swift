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
    var navigationBarStyle = NavigationBarStyle.default
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
        navigationTitleView = NavigationTitleView(title: R.string.localizable.manageWalletPageTitle.key.localized())
        self.view.backgroundColor = .white

        setupTable()
    }

    func setupTable() {
        self.tableView.backgroundColor = .white

        form +++
            Section {
                $0.header = HeaderFooterView<ManageWalletHeaderView>(.class)
                $0.header?.height = { 68.0 }
            }

            <<< ImageRow("manageWalletPageAddressManageCellTitle") {
                $0.cell.titleLab.text =  R.string.localizable.manageWalletPageAddressManageCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
                }.onCellSelection({ [unowned self] _, _  in
                    let vc = AddressManageViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })

            <<< ImageRow("manageWalletPageImportMnemonicCellTitle") {
                $0.cell.titleLab.text =  R.string.localizable.manageWalletPageImportMnemonicCellTitle.key.localized()
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
                }.onCellSelection({ [unowned self] _, _  in
                    let vc = ExportMnemonicViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
