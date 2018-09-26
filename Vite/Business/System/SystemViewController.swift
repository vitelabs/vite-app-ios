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
    fileprivate var viewModel: SystemViewModel

    init() {
        self.viewModel = SystemViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    var didChange: ((_ change: NotificationChanged) -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarStyle.configStyle(navigationBarStyle, viewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var logoutBtn: UIButton = {
        let logoutBtn = UIButton.init(style: .white)
        logoutBtn.setTitle(R.string.localizable.systemPageCellLogoutTitle.key.localized(), for: .normal)
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
        self.tableView.separatorStyle = .none

        SwitchRow.defaultCellSetup = { cell, row in
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins.left = 24
            cell.layoutMargins.right = 24
        }

        form
            +++
            Section {
                $0.header = HeaderFooterView<UIView>(.class)
                $0.header?.height = { 0.0 }
            }
            <<< ImageRow("systemPageCellChangeLanguage") {
                $0.cell.titleLab.text = R.string.localizable.systemPageCellChangeLanguage.key.localized()
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
                $0.cell.bottomSeparatorLine.isHidden = false
            }.onCellSelection({ [unowned self] _, _  in
                self.showChangeLanguageList(isSettingPage: true)
            })

            <<< SwitchRow("systemPageCellLoginPwd") {
                $0.title = R.string.localizable.systemPageCellLoginPwd.key.localized()
                $0.cell.height = { 60 }
                $0.cell.bottomSeparatorLine.isHidden = false
                $0.value = self.viewModel.isSwitchPwdBehaviorRelay.value
            }.cellUpdate({ (cell, _) in
                    cell.textLabel?.textColor = Colors.cellTitleGray
                    cell.textLabel?.font = Fonts.descFont
                }) .onChange { [unowned self] row in
                    self.didChange?(.state(isEnabled: row.value ?? false))
            }

            <<< SwitchRow("systemPageCellLoginFaceId") {
                $0.title = R.string.localizable.systemPageCellLoginFaceId.key.localized()
                $0.value = self.viewModel.isSwitchTouchIdBehaviorRelay.value
                $0.cell.height = { 60 }
               $0.cell.bottomSeparatorLine.isHidden = false
                $0.hidden = "$systemPageCellLoginPwd == false"
            }.cellUpdate({ (cell, _) in
                    cell.textLabel?.textColor = Colors.cellTitleGray
                    cell.textLabel?.font = Fonts.descFont
                }) .onChange { [unowned self] row in
                    self.didChange?(.state(isEnabled: row.value ?? false))
            }

            <<< SwitchRow("systemPageCellTransferFaceId") {
                $0.title = R.string.localizable.systemPageCellTransferFaceId.key.localized()
                $0.value = self.viewModel.isSwitchTransferBehaviorRelay.value
                $0.cell.height = { 60 }
                $0.cell.bottomSeparatorLine.isHidden = false
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
}

extension SystemViewController {
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
