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

    enum ItemModel {
        case defaultAddress(address: String)
        case addressHeaderTitle
        case address(viewModel: AddressManageAddressViewModelType)
        case generateAddress
    }

    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ItemModel>>

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    fileprivate func setupView() {
        navigationItem.title = R.string.localizable.addressManagePageTitle()
    }

    fileprivate let dataSource = DataSource(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        switch item {
        case .defaultAddress(let address):
            let cell: AddressManageDefaultAddressCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bind(address: address)
            return cell
        case .addressHeaderTitle:
            let cell: AddressManageAddressHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .address(let viewModel):
            let cell: AddressManageAddressCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bind(viewModel: viewModel)
            return cell
        case .generateAddress:
            let cell: AddressManageGenerateAddressCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    })

    let accountDriver = HDWalletManager.instance.accountDriver
    var tableViewModel: AddressManagerTableViewModel!

    fileprivate func bind() {
        tableViewModel = AddressManagerTableViewModel()

        Observable.combineLatest(tableViewModel.defaultAddressDriver.asObservable(),
                                 tableViewModel.addressesDriver.asObservable())
            .map { [unowned self] defaultAddress, addresses in
                if self.tableViewModel.canGenerateAddress {
                    return [SectionModel(model: "defaultAddress", items: [ItemModel.defaultAddress(address: defaultAddress)]),
                            SectionModel(model: "header", items: [ItemModel.addressHeaderTitle]),
                            SectionModel(model: "addresses", items: addresses.map { ItemModel.address(viewModel: $0) }),
                            SectionModel(model: "generate", items: [ItemModel.generateAddress]),
                    ]
                } else {
                    return [SectionModel(model: "defaultAddress", items: [ItemModel.defaultAddress(address: defaultAddress)]),
                            SectionModel(model: "header", items: [ItemModel.addressHeaderTitle]),
                            SectionModel(model: "addresses", items: addresses.map { ItemModel.address(viewModel: $0) }),
                    ]
                }
            }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)

        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let `self` = self else { fatalError() }

                if let itemModel = (try? self.dataSource.model(at: indexPath)) as? ItemModel {
                    switch itemModel {
                    case .address:
                        self.tableView.deselectRow(at: indexPath, animated: true)
                        self.tableViewModel.setDefaultAddressIndex(indexPath.row)
                    case .generateAddress:
                        self.tableViewModel.generateAddress()
                    default:
                        break
                    }
                }
            }
            .disposed(by: rx.disposeBag)

    }
}
