//
//  ManageWalletViewController.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Eureka
import Vite_keystore
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
                    m.top.equalTo(view.safeAreaLayoutGuideSnpTop)
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
        self.tableView.separatorStyle = .none

        form +++
            Section {section in
                var header = HeaderFooterView<ManageWalletHeaderView>(.class)
                header.onSetupView = { view, section in
                    view.delegate = self
                    view.nameLab.text = WalletDataService.shareInstance.defaultWalletAccount?.name
                }
                header.height = { 68.0 }
                section.header = header
                section.tag = "ManageWalletHeaderView"
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
                self.verifyWalletPassword(callback: {
                      let vc = ExportMnemonicViewController()
                      self.navigationController?.pushViewController(vc, animated: true)
                })
            })

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!)
            make.left.right.bottom.equalTo(self.view)
        }
    }

    func changeWalletName(callback: @escaping () -> Void) {
        let controller = UIAlertController(title: nil, message: R.string.localizable.manageWalletPageAlterChangeName.key.localized(), preferredStyle: UIAlertControllerStyle.alert)

        let cancelAction = UIAlertAction(title: R.string.localizable.cancel.key.localized(), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: R.string.localizable.confirm.key.localized(), style: UIAlertActionStyle.default) { (_) in
            let textField = (controller.textFields?.first)! as UITextField
            let name = textField.text ?? ""

            if name.isEmpty {
                self.view.showToast(str: R.string.localizable.mnemonicBackupPageErrorTypeName.key.localized())
                return
            }
            if !ViteInputValidator.isValidWalletName(str: name  ) {
                self.view.showToast(str: R.string.localizable.mnemonicBackupPageErrorTypeNameValid.key.localized())

                return
            }
            if !ViteInputValidator.isValidWalletNameCount(str: name  ) {
                self.view.showToast(str: R.string.localizable.mnemonicBackupPageErrorTypeValidWalletNameCount.key.localized())
                return
            }

            self.view.displayLoading(text: R.string.localizable.manageWalletPageChangeNameLoading.key.localized(), animated: true)
            DispatchQueue.global().async {
                let wallet =  WalletDataService.shareInstance.defaultWalletAccount ?? WalletAccount()
                wallet.name = name
                WalletDataService.shareInstance.updateWallet(account: wallet )
                DispatchQueue.main.async {
                    self.view.hideLoading()
                    let section = self.form.sectionBy(tag: "ManageWalletHeaderView")
                    section?.reload()
                }
            }
        }
        controller.addTextField { (textfield) in
            textfield.text = WalletDataService.shareInstance.defaultWalletAccount?.name
        }
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
}

extension ManageWalletViewController: ManageWalletHeaderViewDelegate {
    func changeNameAction() {
        self.changeWalletName {

        }
    }
}
