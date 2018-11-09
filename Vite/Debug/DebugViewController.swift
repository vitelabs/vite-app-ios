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
                $0.header = HeaderFooterView(title: "App")
            }
            <<< LabelRow("appEnvironment") {
                $0.title = "Environment"
                $0.value = DebugService.instance.appEnvironment.name
            }.onCellSelection { _, _ in

                var actions = DebugService.AppEnvironment.allValues.map { config -> (Alert.UIAlertControllerAletrActionTitle, ((UIAlertController) -> Void)?) in
                    (.default(title: config.name), { alert in

                        guard let cell = self.form.rowBy(tag: "appEnvironment") as? LabelRow else { return }
                        DebugService.instance.appEnvironment = config
                        cell.value = config.name
                        cell.updateCell()

                        guard let useBigDifficultyCell = self.form.rowBy(tag: "useBigDifficulty") as? SwitchRow else { return }
                        useBigDifficultyCell.value = DebugService.instance.useBigDifficulty
                        useBigDifficultyCell.updateCell()

                        guard let rpcUseOnlineUrlCell = self.form.rowBy(tag: "rpcUseOnlineUrl") as? SwitchRow else { return }
                        rpcUseOnlineUrlCell.value = DebugService.instance.rpcUseOnlineUrl
                        rpcUseOnlineUrlCell.updateCell()

                        guard let rpcCustomUrlCell = self.form.rowBy(tag: "rpcCustomUrl") as? LabelRow else { return }
                        if let _ = URL(string: DebugService.instance.rpcCustomUrl) {
                            rpcCustomUrlCell.title = "Custom URL"
                            rpcCustomUrlCell.value = DebugService.instance.rpcCustomUrl
                        } else {
                            rpcCustomUrlCell.title = "Test URL"
                            rpcCustomUrlCell.value = DebugService.instance.rpcDefaultTestEnvironmentUrl.absoluteString
                        }
                        rpcCustomUrlCell.updateCell()

                        guard let configEnvironmentCell = self.form.rowBy(tag: "configEnvironment") as? LabelRow else { return }
                        configEnvironmentCell.value = DebugService.instance.configEnvironment.name
                        configEnvironmentCell.updateCell()
                    })
                }

                actions.append((.cancel, nil))
                ActionSheet.show(into: self, title: "Select App Environment", message: nil, actions: actions)
            }
            +++
            Section {
                $0.header = HeaderFooterView(title: "Wallet")
            }
            <<< SwitchRow("useBigDifficulty") {
                $0.title = "Use Big Difficulty"
                $0.value = DebugService.instance.useBigDifficulty
            }.onChange { row in
                guard let ret = row.value else { return }
                DebugService.instance.useBigDifficulty = ret
                guard let cell = self.form.rowBy(tag: "appEnvironment") as? LabelRow else { return }
                cell.value = DebugService.instance.appEnvironment.name
                cell.updateCell()
            }
            +++
            Section {
                $0.header = HeaderFooterView(title: "RPC")
            }
            <<< SwitchRow("rpcUseOnlineUrl") {
                $0.title = "Use Online URL"
                $0.value = DebugService.instance.rpcUseOnlineUrl
            }.onChange { row in
                guard let ret = row.value else { return }
                DebugService.instance.rpcUseOnlineUrl = ret
                guard let cell = self.form.rowBy(tag: "appEnvironment") as? LabelRow else { return }
                cell.value = DebugService.instance.appEnvironment.name
                cell.updateCell()
            }
            <<< LabelRow("rpcCustomUrl") {
                $0.hidden = "$rpcUseOnlineUrl == true"
                if let _ = URL(string: DebugService.instance.rpcCustomUrl) {
                    $0.title = "Custom URL"
                    $0.value = DebugService.instance.rpcCustomUrl
                } else {
                    $0.title = "Test URL"
                    $0.value = DebugService.instance.rpcDefaultTestEnvironmentUrl.absoluteString
                }
            }.onCellSelection({ _, _  in
                Alert.show(into: self, title: "RPC Custom URL", message: nil, actions: [
                    (.cancel, nil),
                    (.default(title: "OK"), { alert in
                        guard let cell = self.form.rowBy(tag: "rpcCustomUrl") as? LabelRow else { return }
                        if let text = alert.textFields?.first?.text, (text.hasPrefix("http://") || text.hasPrefix("https://")), let _ = URL(string: text) {
                            DebugService.instance.rpcCustomUrl = text
                            cell.title = "Custom"
                            cell.value = text
                            cell.updateCell()
                        } else if let text = alert.textFields?.first?.text, text.isEmpty {
                            DebugService.instance.rpcCustomUrl = ""
                            cell.title = "Test"
                            cell.value = DebugService.instance.rpcDefaultTestEnvironmentUrl.absoluteString
                            cell.updateCell()
                        } else {
                            Toast.show("Error Format")
                        }
                        guard let appCell = self.form.rowBy(tag: "appEnvironment") as? LabelRow else { return }
                        appCell.value = DebugService.instance.appEnvironment.name
                        appCell.updateCell()
                    }),
                    ], config: { alert in
                        alert.addTextField(configurationHandler: { (textField) in
                            textField.clearButtonMode = .always
                            textField.text = DebugService.instance.rpcCustomUrl
                            textField.placeholder = DebugService.instance.rpcDefaultTestEnvironmentUrl.absoluteString
                        })
                })
            })
            +++
            Section {
                $0.header = HeaderFooterView(title: "Config")
            }
            <<< LabelRow("configEnvironment") {
                $0.title = "Config Environment"
                $0.value = DebugService.instance.configEnvironment.name
            }.onCellSelection { _, _ in

                var actions = DebugService.ConfigEnvironment.allValues.map { config -> (Alert.UIAlertControllerAletrActionTitle, ((UIAlertController) -> Void)?) in
                    (.default(title: config.name), { alert in
                        guard let cell = self.form.rowBy(tag: "configEnvironment") as? LabelRow else { return }
                        DebugService.instance.configEnvironment = config
                        cell.value = config.name
                        cell.updateCell()
                        guard let appCell = self.form.rowBy(tag: "appEnvironment") as? LabelRow else { return }
                        appCell.value = DebugService.instance.appEnvironment.name
                        appCell.updateCell()
                    })
                }

                actions.append((.cancel, nil))
                ActionSheet.show(into: self, title: "Select Config Environment", message: nil, actions: actions)
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
            +++
            Section {
                $0.header = HeaderFooterView(title: "Operation")
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
