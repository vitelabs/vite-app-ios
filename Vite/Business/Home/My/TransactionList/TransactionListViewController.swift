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

        navigationTitleView = NavigationTitleView(title: R.string.localizable.transactionListPageTitle.key.localized())

        tableView.separatorStyle = .none
        tableView.rowHeight = TransactionCell.cellHeight
        tableView.estimatedRowHeight = TransactionCell.cellHeight
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.refreshList(finished: { [weak self] in
                self?.tableView.mj_header.endRefreshing()
            })
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

        let endScroll = Observable.merge(tableView.rx.didEndDragging.filter { !$0 }.map { _ in Swift.Void() }.asObservable(),
                                         tableView.rx.didEndDecelerating.asObservable())
        endScroll
            .filter { [unowned self] in
                guard let footerView = self.tableView.tableFooterView else { return false }
                let triggerOffset = self.tableView.frame.height / 2
                let frame = footerView.superview!.convert(footerView.frame, to: self.view)
                return frame.origin.y < self.view.frame.height + triggerOffset
            }
            .bind { [unowned self] in
                self.getMore()
            }
            .disposed(by: rx.disposeBag)

        footerView.retry.throttle(0.5, scheduler: MainScheduler.instance)
            .bind { [unowned self] in
                self.getMore()
                self.footerView.status = .loading
            }
            .disposed(by: rx.disposeBag)

        dataStatus = .loading
        refreshList()
    }

    private func getMore(finished: (() -> Void)? = nil) {
        self.tableViewModel.getMore { error in
            if let error = error {
                self.footerView.status = .failed
                print(error)
            }
        }
    }

    private func refreshList(finished: (() -> Void)? = nil) {
        tableViewModel.refreshList { [weak self] error in
            if let f = finished {
                f()
            }

            if let error = error {
                self?.dataStatus = .networkError(error, { [weak self] in
                    self?.refreshList()
                })
            } else {
                self?.dataStatus = .normal
            }
        }
    }
}

extension TransactionListViewController: ViewControllerDataStatusable {

    func networkErrorView(error: Error, retry: @escaping () -> Void) -> UIView {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.red
        button.setTitle(error.localizedDescription, for: .normal)
        button.rx.tap.bind { [weak self] in
            self?.dataStatus = .loading
            retry()
        }.disposed(by: rx.disposeBag)
        return button
    }
}
