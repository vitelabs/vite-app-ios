//
//  WalletHomeViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import Vite_keystore

class WalletHomeViewController: BaseTableViewController {

    enum ItemModel {
        case address(viewModel: WalletHomeAddressViewModelType)
        case balanceInfo(viewModel: WalletHomeBalanceInfoViewModelType)
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ItemModel>>

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    let account = WalletDataService.shareInstance.defaultWalletAccount
    var addressViewModel: WalletHomeAddressViewModel!
    var tableViewModel: WalletHomeBalanceInfoTableViewModel!
    weak var balanceInfoDetailViewController: BalanceInfoDetailViewController?

    fileprivate func setupView() {

        let qrcodeItem = UIBarButtonItem(image: R.image.bar_icon_qrcode(), style: .plain, target: nil, action: nil)
        let scanItem = UIBarButtonItem(image: R.image.bar_icon_scan(), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = qrcodeItem
        navigationItem.rightBarButtonItem = scanItem

        qrcodeItem.rx.tap.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.navigationController?.pushViewController(QRCodeViewController(account: self.account), animated: true)
        }.disposed(by: rx.disposeBag)

        scanItem.rx.tap.bind {  [weak self] _ in
            self?.navigationController?.pushViewController(ScanViewController(), animated: true)
        }.disposed(by: rx.disposeBag)

    }

    fileprivate let dataSource = DataSource(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        switch item {
        case .address(let viewModel):
            let cell: WalletHomeAddressCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bind(viewModel: viewModel)
            return cell
        case .balanceInfo(let viewModel):
            let cell: WalletHomeBalanceInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bind(viewModel: viewModel)
            return cell
        }
    })

    fileprivate func bind() {

        addressViewModel = WalletHomeAddressViewModel(account: self.account)
        tableViewModel = WalletHomeBalanceInfoTableViewModel(address: Address(string: self.account.defaultKey.address))

        Observable.combineLatest(Observable.just(addressViewModel),
                                 tableViewModel.balanceInfosDriver.asObservable())
            .map { addressViewModel, balanceInfoViewModels in
                [SectionModel(model: "address", items: [ItemModel.address(viewModel: addressViewModel)]),
                 SectionModel(model: "balanceInfo", items: balanceInfoViewModels.map { ItemModel.balanceInfo(viewModel: $0) }),
                 ]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let `self` = self else { fatalError() }

                if let itemModel = (try? self.dataSource.model(at: indexPath)) as? ItemModel {
                    switch itemModel {
                    case .balanceInfo(let viewModel):
                            self.tableView.deselectRow(at: indexPath, animated: true)
                            let balanceInfoDetailViewController = BalanceInfoDetailViewController(viewModel: viewModel)
                            self.navigationController?.pushViewController(balanceInfoDetailViewController, animated: true)
                            self.balanceInfoDetailViewController = balanceInfoDetailViewController
                    default:
                        break
                    }
                }
            }
            .disposed(by: rx.disposeBag)

        tableViewModel.balanceInfosDriver.asObservable().bind { [weak self] in
            if let viewModelBehaviorRelay = self?.balanceInfoDetailViewController?.viewModelBehaviorRelay {
                for viewModel in $0 where viewModelBehaviorRelay.value.tokenId == viewModel.tokenId {
                    viewModelBehaviorRelay.accept(viewModel)
                    break
                }
            }
        }.disposed(by: rx.disposeBag)
    }
}
