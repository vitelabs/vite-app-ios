//
//  SystemViewController.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Eureka
import SafariServices

struct Preferences: Codable {

}

enum NotificationChanged {
    case state(isEnabled: Bool)
    case preferences(Preferences)
}

class SystemViewController: FormViewController {
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

    var didChange: ((_ change: NotificationChanged) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var logoutBtn: UIButton = {
        let logoutBtn = UIButton.init(style: .white)
        logoutBtn.setTitle("退出并切换钱包", for: .normal)
        logoutBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        logoutBtn.addTarget(self, action: #selector(logoutBtnAction), for: .touchUpInside)
        return logoutBtn
    }()

    private func _setupView() {
        navigationTitleView = NavigationTitleView(title: R.string.localizable.myPageSystemCellTitle.key.localized())
        self.view.backgroundColor = .white

        self.setupTableView()

        self.view.addSubview(self.logoutBtn)
        self.logoutBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }
    }

    func setupTableView() {
        self.tableView.backgroundColor = .white

        form
            +++
            Section {
                $0.header = HeaderFooterView<UIView>(.class)
                $0.header?.height = { 0.0 }
            }
            <<< ImageRow("my.page.message1.cell.title") {
                $0.cell.titleLab.text = "语言选择"
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
            }.onCellSelection({ [unowned self] _, _  in
                self.showChangeLanguageList(isSettingPage: true)
            })

            <<< SwitchRow("my.page.system2.cell.title") {
                $0.title = "输入密码唤起app"
                $0.value = true
                $0.cell.height = { 60 }
            }.cellUpdate({ (cell, _) in
                    cell.textLabel?.textColor = Colors.cellTitleGray
                    cell.textLabel?.font = Fonts.descFont
                }) .onChange { [unowned self] row in
                    self.didChange?(.state(isEnabled: row.value ?? false))
            }

            <<< SwitchRow("my.page.system.3cell.title") {
                $0.title = "支持指纹/面部识别"
                $0.value = true
                $0.cell.height = { 60 }
            }.cellUpdate({ (cell, _) in
                    cell.textLabel?.textColor = Colors.cellTitleGray
                    cell.textLabel?.font = Fonts.descFont
                }) .onChange { [unowned self] row in
                    self.didChange?(.state(isEnabled: row.value ?? false))
            }

            <<< SwitchRow("my.page.system.3ceddll.title") {
                $0.title = "转账开启指纹/面部识别"
                $0.value = true
                $0.cell.height = { 60 }
            }.cellUpdate({ (cell, _) in
                    cell.textLabel?.textColor = Colors.cellTitleGray
                    cell.textLabel?.font = Fonts.descFont
                }) .onChange { [unowned self] row in
                    self.didChange?(.state(isEnabled: row.value ?? false))
            }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!)
            make.left.right.bottom.equalTo(self.view)
        }
    }

    @objc func logoutBtnAction() {
        self.view.displayLoading(text: R.string.localizable.systemPageLogoutLoading.key.localized(), animated: true)
        DispatchQueue.global().async {
            HDWalletManager.instance.cleanAccount()
            WalletDataService.shareInstance.logoutCurrentWallet()
            DispatchQueue.main.async {
                self.view.hideLoading()
                NotificationCenter.default.post(name: .logoutDidFinish, object: nil)
            }
        }
    }
}
