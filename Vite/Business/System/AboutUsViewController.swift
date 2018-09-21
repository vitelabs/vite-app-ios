//
//  AboutUsViewController.swift
//  Vite
//
//  Created by Water on 2018/9/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import UIKit
import Eureka
import SnapKit
import Vite_keystore

class AboutUsViewController: FormViewController {
    var navigationBarStyle = NavigationBarStyle.default

    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarStyle.configStyle(navigationBarStyle, viewController: self)
    }

    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.backgroundColor = .clear
        logoImgView.image =  R.image.login_logo()
        return logoImgView
    }()
}

extension AboutUsViewController {

    private func _setupView() {
        self._addViewConstraint()
        setupTableView()
    }

    func setupTableView() {
        self.tableView.backgroundColor = .white
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 146))
        headerView.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { (make) in
            make.center.equalTo(headerView)
            make.width.height.equalTo(84)
        }
        self.tableView.tableHeaderView = headerView

        let bottomView = AboutUsTableBottomView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 270) )
        self.tableView.tableFooterView = bottomView

        form +++
            Section {
                $0.header = HeaderFooterView<UIView>(.class)
                $0.header?.height = { 0.0 }
            }

            <<< LabelRow("aboutUsPageCellBlockHeight") {
                $0.title =  R.string.localizable.aboutUsPageCellBlockHeight.key.localized()
                $0.cell.height = { 60 }
            }.onCellSelection({ [unowned self] _, _  in
//TODO  fetch data
                })

            <<< LabelRow("aboutUsPageCellVersion") {
                $0.title =  R.string.localizable.aboutUsPageCellVersion.key.localized()
                $0.value = String.getAppVersion()
                $0.cell.height = { 60 }
            }.onCellSelection({ [unowned self] _, _  in

                self.view.displayLoading(text: R.string.localizable.systemPageLogoutLoading.key.localized(), animated: true)
                DispatchQueue.global().async {
                    HDWalletManager.instance.cleanAccount()
                    WalletDataService.shareInstance.delAllWalletData()
                    DispatchQueue.main.async {
                        self.view.hideLoading()
                        NotificationCenter.default.post(name: .logoutDidFinish, object: nil)
                    }
                }
                })

            <<< ImageRow("aboutUsPageCellContact") {
                $0.cell.titleLab.text =  R.string.localizable.aboutUsPageCellContact.key.localized()
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
            }.onCellSelection({ [unowned self] _, _  in
                    let vc = FetchWelfareViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })

            <<< ImageRow("aboutUsPageCellShareUs") {
                $0.cell.titleLab.text =  R.string.localizable.aboutUsPageCellShareUs.key.localized()
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
            }.onCellSelection({ [unowned self] _, _  in
                    let vc = FetchWelfareViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuideSnpTop)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    private func _addViewConstraint() {

    }
}
