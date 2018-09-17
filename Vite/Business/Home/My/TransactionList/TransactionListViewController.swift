//
//  TransactionListViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import MJRefresh

class TransactionListViewController: BaseTableViewController {

    let address = HDWalletManager.instance.bag().address

    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TransactionViewModelType>>

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    var tableViewModel: TransactionListTableViewModel!

    fileprivate func setupView() {

        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.tableViewModel.refreshList { [weak self] in
                self?.tableView.mj_header.endRefreshing()
            }
        })

    }

    let dataSource = DataSource(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        cell.bind(viewModel: item, index: indexPath.row)
        return cell
    })

    let footerView = GetMoreLoadingView(frame: CGRect(x: 0, y: 0, width: 0, height: 80))

    func bind() {
        tableViewModel = TransactionListTableViewModel(address: address)

        tableViewModel.hasMore.asObservable().bind { [weak self] in
            self?.tableView.tableFooterView = $0 ? self?.footerView : nil
        }.disposed(by: rx.disposeBag)

        tableViewModel.transactionsDriver.asObservable().map { String($0.count) }.bind(to: navigationItem.rx.title).disposed(by: rx.disposeBag)

        tableViewModel.transactionsDriver.asObservable()
            .map { [SectionModel(model: "transaction", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let `self` = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                if let viewModel = (try? self.dataSource.model(at: indexPath)) as? TransactionViewModelType {
                    WebHandler.openTranscationDetailPage(hash: viewModel.hash)
                }
            }
            .disposed(by: rx.disposeBag)

        tableView.rx.didScroll.asObservable().bind { [weak self] in
            guard let `self` = self else { return }
            guard let footerView = self.tableView.tableFooterView else { return }

            let triggerOffset = self.tableView.frame.height / 2
            let frame = footerView.superview!.convert(footerView.frame, to: self.view)
            if frame.origin.y < self.view.frame.height + triggerOffset {
                self.tableViewModel.getMore()
            }

        }.disposed(by: rx.disposeBag)

        dataStatus = .loading
        tableViewModel.refreshList { [weak self] in
            self?.dataStatus = .normal
        }
    }
}

extension TransactionListViewController: ViewControllerDataStatusable {

}
