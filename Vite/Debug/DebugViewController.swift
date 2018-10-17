//
//  DebugViewController.swift
//  Vite
//
//  Created by Stone on 2018/10/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Eureka

class DebugViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {

        navigationItem.title = "Debug"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.icon_nav_back_black(), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(_onCancel))

        form
            +++
            Section { _ in }
            <<< LabelRow("deleteAllWallets") {
                $0.title =  "Delete All Wallets"
            }.onCellSelection({ [unowned self]  _, _  in
                self.view.displayLoading(text: R.string.localizable.systemPageLogoutLoading.key.localized(), animated: true)
                DispatchQueue.global().async {
                    HDWalletManager.instance.deleteAllWallets()
                    KeychainService.instance.clearCurrentWallet()
                    DispatchQueue.main.async {
                        self.view.hideLoading()
                        NotificationCenter.default.post(name: .logoutDidFinish, object: nil)
                    }
                }
            })
            <<< LabelRow("resetCurrentWalletBagCount") {
                $0.title =  "Reset Current Wallet Bag Count"
            }.onCellSelection({ _, _  in
                HDWalletManager.instance.resetBagCount()
                Toast.show("Operation complete")
            })
    }

    @objc fileprivate func _onCancel() {
        dismiss(animated: true, completion: nil)
    }
}
