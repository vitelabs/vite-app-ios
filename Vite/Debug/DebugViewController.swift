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
            Section {
                $0.header = HeaderFooterView(title: "Wallet")
            }
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
            <<< SwitchRow("useBigDifficulty") {
                $0.title = "Use Big Difficulty"
                $0.value = DebugService.instance.useBigDifficulty
            }.onChange { row in
                    guard let ret = row.value else { return }
                    DebugService.instance.useBigDifficulty = ret
            }
            +++
            Section {
                $0.header = HeaderFooterView(title: "Network")
            }
            <<< SwitchRow("rpcUseHttp") {
                $0.title = "RPC Use HTTP"
                $0.value = DebugService.instance.rpcUseHTTP
            }.onChange { row in
                    guard let ret = row.value else { return }
                    DebugService.instance.rpcUseHTTP = ret
            }
            +++
            Section {
                $0.header = HeaderFooterView(title: "Statistics")
            }
            <<< LabelRow("testStatistics") {
                $0.title =  "Test Statistics"
            }.onCellSelection({ _, _  in
                Statistics.log(eventId: Statistics.Page.Debug.test.rawValue)
            })
            <<< SwitchRow("showStatisticsToast") {
                $0.title = "Show Statistics Toast"
                $0.value = DebugService.instance.showStatisticsToast
            }.onChange { row in
                guard let ret = row.value else { return }
                DebugService.instance.showStatisticsToast = ret
            }
            <<< SwitchRow("reportEventInDebug") {
                $0.title = "Report Event In Debug"
                $0.value = DebugService.instance.reportEventInDebug
            }.onChange { row in
                guard let ret = row.value else { return }
                DebugService.instance.reportEventInDebug = ret
            }
        #endif
    }

    @objc fileprivate func _onCancel() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Statistics.pageviewStart(with: Statistics.Page.Debug.name)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Statistics.pageviewEnd(with: Statistics.Page.Debug.name)
    }
}
