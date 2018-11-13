//
//  MyHomeViewController.swift
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

class MyHomeViewController: BaseTableViewController {

    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MyHomeListCellViewModel>>

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    fileprivate func setupView() {
        navigationTitleView = NavigationTitleView(title: R.string.localizable.myPageTitle.key.localized())
        let headerView = MyHomeListHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 116))
        headerView.delegate = self
        tableView.tableHeaderView = headerView
    }

    fileprivate let dataSource = DataSource(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell: MyHomeListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.bind(viewModel: item)
        return cell
    })

    fileprivate func bind() {
        AppSettingsService.instance.configDriver.asObservable().map { config -> [SectionModel<String, MyHomeListCellViewModel>] in
            let configViewModel = MyHomeConfigViewModel(JSON: config.myPage)!
            return [SectionModel(model: "item", items: configViewModel.items)]
        }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        tableView.separatorStyle = .none
        tableView.rowHeight = MyHomeListCell.cellHeight
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let `self` = self else { fatalError() }
                if let viewModel = (try? self.dataSource.model(at: indexPath)) as? MyHomeListCellViewModel {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    viewModel.clicked(viewController: self)
                }
            }
            .disposed(by: rx.disposeBag)
    }
}

extension MyHomeViewController: MyHomeListHeaderViewDelegate {
    func transactionLogBtnAction() {
        let vc = TransactionListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func manageWalletBtnAction() {
        let vc = ManageWalletViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func manageQuotaBtnAction() {
        let vc = QuotaManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
