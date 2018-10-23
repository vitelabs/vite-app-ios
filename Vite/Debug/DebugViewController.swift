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

        #if DEBUG
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
            <<< LabelRow("deleteTokenCache") {
                $0.title =  "Delete Token Cache"
            }.onCellSelection({ _, _  in
                    TokenCacheService.instance.deleteCache()
                    Toast.show("Operation complete")
                })

            +++
            Section {
                $0.header = HeaderFooterView<UIView>(.class)
                $0.header?.height = { 0.01 }
                $0.header?.title = "web bridge"
            }
            <<< LabelRow("webBridge") {
                $0.title =  "web Bridge"
            }.onCellSelection({ _, _  in
                let url = URL.init(string: "http://127.0.0.1/test.html")!
                let web = WKWebViewController.init(url: url)
                    self.navigationController?.pushViewController(web, animated: true)
                })
        #endif
    }

    @objc fileprivate func _onCancel() {
        dismiss(animated: true, completion: nil)
    }
}
