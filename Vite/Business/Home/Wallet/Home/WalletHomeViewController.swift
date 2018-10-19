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
import Vite_HDWalletKit

class WalletHomeViewController: BaseTableViewController {

    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, WalletHomeBalanceInfoViewModelType>>

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    let walletDriver = HDWalletManager.instance.walletDriver
    let addressView = WalletHomeAddressView()
    var addressViewModel: WalletHomeAddressViewModel!
    var tableViewModel: WalletHomeBalanceInfoTableViewModel!
    weak var balanceInfoDetailViewController: BalanceInfoDetailViewController?

    fileprivate func setupView() {

        let qrcodeItem = UIBarButtonItem(image: R.image.icon_nav_qrcode_black(), style: .plain, target: nil, action: nil)
        let scanItem = UIBarButtonItem(image: R.image.icon_nav_scan_black(), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = qrcodeItem
        navigationItem.rightBarButtonItem = scanItem

        navigationTitleView = NavigationTitleView(title: nil)
        customHeaderView = addressView
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = WalletHomeBalanceInfoCell.cellHeight
        tableView.estimatedRowHeight = WalletHomeBalanceInfoCell.cellHeight
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 18)).then {
            $0.backgroundColor = UIColor.clear
        }

        if #available(iOS 11.0, *) {

        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }

        let shadowView = UIView().then {
            $0.backgroundColor = UIColor.white
            $0.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 20
        }

        view.insertSubview(shadowView, belowSubview: tableView)
        shadowView.snp.makeConstraints { (m) in
            m.left.right.equalTo(tableView)
            m.bottom.equalTo(tableView.snp.top)
            m.height.equalTo(10)
        }

        qrcodeItem.rx.tap.bind { [weak self] _ in
            self?.navigationController?.pushViewController(ReceiveViewController(token: TokenCacheService.instance.viteToken, style: .default), animated: true)
        }.disposed(by: rx.disposeBag)

        scanItem.rx.tap.bind {  [weak self] _ in
            let scanViewController = ScanViewController()
            scanViewController.reactor = ScanViewReactor()
            self?.navigationController?.pushViewController(scanViewController, animated: true)
        }.disposed(by: rx.disposeBag)
    }

    fileprivate let dataSource = DataSource(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell: WalletHomeBalanceInfoCell = tableView.dequeueReusableCell(for: indexPath)
        cell.bind(viewModel: item)
        return cell
    })

    fileprivate func bind() {

        walletDriver.map({ $0.name }).drive(navigationTitleView!.titleLabel.rx.text).disposed(by: rx.disposeBag)
        addressViewModel = WalletHomeAddressViewModel()
        tableViewModel = WalletHomeBalanceInfoTableViewModel()

        addressView.bind(viewModel: addressViewModel)

        tableViewModel.balanceInfosDriver.asObservable()
            .map { balanceInfoViewModels in
                [SectionModel(model: "balanceInfo", items: balanceInfoViewModels)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let `self` = self else { fatalError() }
                if let viewModel = (try? self.dataSource.model(at: indexPath)) as? WalletHomeBalanceInfoViewModelType {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    let balanceInfoDetailViewController = BalanceInfoDetailViewController(viewModel: viewModel)
                    self.navigationController?.pushViewController(balanceInfoDetailViewController, animated: true)
                    self.balanceInfoDetailViewController = balanceInfoDetailViewController
                }
            }
            .disposed(by: rx.disposeBag)

        tableViewModel.balanceInfosDriver.asObservable().bind { [weak self] in
            if let viewModelBehaviorRelay = self?.balanceInfoDetailViewController?.viewModelBehaviorRelay {
                for viewModel in $0 where viewModelBehaviorRelay.value.token.id == viewModel.token.id {
                    viewModelBehaviorRelay.accept(viewModel)
                    break
                }
            }
        }.disposed(by: rx.disposeBag)
    }
}
