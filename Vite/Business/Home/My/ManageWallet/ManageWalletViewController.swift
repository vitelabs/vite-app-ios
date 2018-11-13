//
//  ManageWalletViewController.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Eureka
import Vite_HDWalletKit
import SafariServices
import RxCocoa
import RxSwift

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

    private var subscription: Disposable?
    private var nameTextField: UITextField?

    func setupTable() {
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none

        ImageRow.defaultCellSetup = { cell, row in
            cell.selectionStyle = .none
        }

        form +++
            Section {section in
                var header = HeaderFooterView<ManageWalletHeaderView>(.class)
                header.onSetupView = { [unowned self] view, section in
                    view.nameTextField.text = HDWalletManager.instance.wallet?.name
                    self.subscription?.dispose()
                    self.subscription = Observable.merge([
                        view.nameTextField.rx.methodInvoked(#selector(UIResponder.resignFirstResponder)).map { _ in () },
                        view.nameTextField.rx.controlEvent(.editingDidEndOnExit).map { () }
                        ])
                    .debounce(0.5, scheduler: MainScheduler.instance)
                    .bind(onNext: { (_) in
                        self.changeWalletName(name: view.nameTextField.text)
                    })
                    self.subscription?.disposed(by: self.rx.disposeBag)
                    self.nameTextField = view.nameTextField
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

    func changeWalletName(name: String?) {

        let name = name ?? ""
        var changed = false

        defer {
            if !changed {
                self.nameTextField?.text = HDWalletManager.instance.wallet?.name
            }
        }

        if name.isEmpty {
            self.view.showToast(str: R.string.localizable.manageWalletPageErrorTypeName.key.localized())
            return
        }
        if !ViteInputValidator.isValidWalletName(str: name ) {
            self.view.showToast(str: R.string.localizable.mnemonicBackupPageErrorTypeNameValid.key.localized())
            return
        }
        if !ViteInputValidator.isValidWalletNameCount(str: name  ) {
            self.view.showToast(str: R.string.localizable.mnemonicBackupPageErrorTypeValidWalletNameCount.key.localized())
            return
        }
        changed = true
        self.view.displayLoading(text: R.string.localizable.manageWalletPageChangeNameLoading.key.localized(), animated: true)
        DispatchQueue.global().async {
            HDWalletManager.instance.updateName(name: name)
            DispatchQueue.main.async {
                self.view.hideLoading()
                let section = self.form.sectionBy(tag: "ManageWalletHeaderView")
                section?.reload()
            }
        }

    }

}
