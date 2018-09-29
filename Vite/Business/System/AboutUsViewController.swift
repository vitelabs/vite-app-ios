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
import RxSwift
import RxCocoa
import NSObject_Rx
import MessageUI
import Vite_HDWalletKit

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
        logoImgView.image =  R.image.aboutus_logo()
        return logoImgView
    }()
}

extension AboutUsViewController {

    private func _setupView() {
        setupTableView()
    }

    func setupTableView() {
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none

        LabelRow.defaultCellSetup = { cell, row in
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins.left = 24
            cell.layoutMargins.right = 24
        }

        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 176))
        headerView.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView).offset(30)
            make.centerX.equalTo(headerView)
            make.width.equalTo(82)
            make.width.height.equalTo(116)
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
                $0.value = R.string.localizable.aboutUsPageCellBlockHeightLoadingTip()
                $0.cell.height = { 60 }
                $0.cell.bottomSeparatorLine.isHidden = false
            }.onCellSelection({ _, _  in
                })

            <<< LabelRow("aboutUsPageCellVersion") {
                $0.title =  R.string.localizable.aboutUsPageCellVersion.key.localized()
                $0.value = Bundle.main.fullVersion
                $0.cell.height = { 60 }
                $0.cell.bottomSeparatorLine.isHidden = false
            }.onCellSelection({ [unowned self] _, _  in

                #if DEBUG
                self.view.displayLoading(text: R.string.localizable.systemPageLogoutLoading.key.localized(), animated: true)
                DispatchQueue.global().async {
                    HDWalletManager.instance.cleanAccount()
                    WalletDataService.shareInstance.delAllWalletData()
                    DispatchQueue.main.async {
                        self.view.hideLoading()
                        NotificationCenter.default.post(name: .logoutDidFinish, object: nil)
                    }
                }
                #endif

                })

            <<< ImageRow("aboutUsPageCellContact") {
                $0.cell.titleLab.text =  R.string.localizable.aboutUsPageCellContact.key.localized()
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
            }.onCellSelection({ [unowned self] _, _  in
                self.sendUsEmail()
                })

            <<< ImageRow("aboutUsPageCellShareUs") {
                $0.cell.titleLab.text =  R.string.localizable.aboutUsPageCellShareUs.key.localized()
                $0.cell.rightImageView.image = R.image.icon_right_white()?.tintColor(Colors.titleGray).resizable
            }.onCellSelection({ [unowned self] _, _  in
                //TODO:::  调面板，分享下载的url
            })

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuideSnpTop)
            make.left.right.bottom.equalTo(self.view)
        }

        getSnapshotChainHeight()
        Observable<Int>.interval(3, scheduler: MainScheduler.instance).bind { [weak self] _ in self?.getSnapshotChainHeight() }.disposed(by: rx.disposeBag)
    }

    func getSnapshotChainHeight() {
        Provider.instance.getSnapshotChainHeight(completion: { [weak self] (result) in
            guard let `self` = self else { return }
            guard let cell = self.form.rowBy(tag: "aboutUsPageCellBlockHeight") as? LabelRow else { return }
            switch result {
            case .success(let string):
                cell.value = string
                cell.updateCell()
            case .error:
                break
            }
        })
    }

    func sendUsEmail() {
        let composerController = MFMailComposeViewController()
        composerController.mailComposeDelegate = self
        composerController.setToRecipients([Constants.supportEmail])
        composerController.setSubject(R.string.localizable.aboutUsPageEmailTitle.key.localized())
        composerController.setMessageBody(emailTemplate(), isHTML: false)

        if MFMailComposeViewController.canSendMail() {
            present(composerController, animated: true, completion: nil)
        }
    }
    private func emailTemplate() -> String {
        return   R.string.localizable.aboutUsPageEmailContent.key.localized(arguments: UIDevice.current.systemVersion, UIDevice.current.model, String.getAppVersion(), Locale.preferredLanguages.first ?? "")
    }
}

extension AboutUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
