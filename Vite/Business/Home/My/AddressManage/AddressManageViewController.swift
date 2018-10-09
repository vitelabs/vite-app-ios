//
//  AddressManageViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources

class AddressManageViewController: BaseTableViewController {

    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, AddressManageAddressViewModelType>>

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    let headerView = AddressManageHeaderView()
    let generateButton = UIButton().then {
        $0.setTitle(R.string.localizable.addressManageAddressGenerateButtonTitle.key.localized(), for: .normal)
        $0.setImage(R.image.icon_button_add(), for: .normal)
        $0.setImage(R.image.icon_button_add(), for: .highlighted)
        $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setBackgroundImage(R.image.background_add_button_white()?.resizable, for: .normal)
        $0.setBackgroundImage(R.image.background_add_button_white()?.tintColor(UIColor(netHex: 0xefefef)).resizable, for: .highlighted)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25 + 10)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.cornerRadius = 2
    }

    fileprivate func setupView() {
        navigationTitleView = NavigationTitleView(title: R.string.localizable.addressManagePageTitle.key.localized())
        customHeaderView = headerView

        tableView.rowHeight = AddressManageAddressCell.cellHeight()
        tableView.estimatedRowHeight = AddressManageAddressCell.cellHeight()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        view.addSubview(generateButton)
        generateButton.snp.makeConstraints { (m) in
            m.centerX.equalTo(view)
            m.bottom.equalTo(view.safeAreaLayoutGuideSnpBottom).offset(-24)
            m.height.equalTo(50)
        }
    }

    fileprivate let dataSource = DataSource(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell: AddressManageAddressCell = tableView.dequeueReusableCell(for: indexPath)
        cell.bind(viewModel: item)
        return cell
    })

    let walletDriver = HDWalletManager.instance.walletDriver
    var tableViewModel: AddressManagerTableViewModel!

    fileprivate func bind() {
        tableViewModel = AddressManagerTableViewModel()

        tableViewModel.addressesDriver.asObservable()
            .map { [SectionModel(model: "addresses", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)

        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let `self` = self else { fatalError() }
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableViewModel.setDefaultAddressIndex(indexPath.row)
            }
            .disposed(by: rx.disposeBag)

        tableViewModel.defaultAddressDriver.drive(headerView.addressLabel.rx.text).disposed(by: rx.disposeBag)
        generateButton.rx.tap.bind { [weak self] in
            guard let `self` = self else { return }
            if self.tableViewModel.canGenerateAddress {
                self.tableViewModel.generateAddress()
            } else {
                Toast.show(R.string.localizable.addressManageAddressGenerateButtonToast.key.localized())
            }
        }.disposed(by: rx.disposeBag)

        headerView.tipButton.rx.tap.bind { [weak self] in
            guard let `self` = self else { return }
            Alert.show(into: self, title: R.string.localizable.hint.key.localized(),
                       message: R.string.localizable.addressManageTipAlertMessage.key.localized(),
                       actions: [(Alert.UIAlertControllerAletrActionTitle.default(title: R.string.localizable.addressManageTipAlertOk.key.localized()), nil)])
        }.disposed(by: rx.disposeBag)
    }
}
