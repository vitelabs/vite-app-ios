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
        let header = RefreshHeader(refreshingBlock: { [weak self] in
            self?.refreshList(finished: { [weak self] in
                self?.tableView.mj_header.endRefreshing()
            })
        })

        tableView.mj_header = header
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

        tableView.rx.didScroll.asObservable().bind { [weak self] in
            guard let `self` = self else { return }
            guard let footerView = self.tableView.tableFooterView else { return }

            let triggerOffset = self.tableView.frame.height / 2
            let frame = footerView.superview!.convert(footerView.frame, to: self.view)
            if frame.origin.y < self.view.frame.height + triggerOffset {
                self.getMore()
            }

        }.disposed(by: rx.disposeBag)

        dataStatus = .loading
        refreshList()
    }

    private func getMore(finished: (() -> Void)? = nil) {
        self.tableViewModel.getMore { error in
            if let error = error {
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
                guard let `self` = self else { return }
                if self.tableView.numberOfRows(inSection: 0) > 0 {
                    self.dataStatus = .normal
                } else {
                    self.dataStatus = .empty
                }

            }
        }
    }
}

extension TransactionListViewController: ViewControllerDataStatusable {

    func networkErrorView(error: Error, retry: @escaping () -> Void) -> UIView {

        let view = UIView()
        let layoutGuide = UILayoutGuide()
        let imageView = UIImageView(image: R.image.network_error())
        let label = UILabel().then {
            $0.textColor = UIColor(netHex: 0x3E4A59).withAlphaComponent(0.45)
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.text = error.localizedDescription
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }

        let button = UIButton(type: .system).then {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
            $0.setTitleColor(UIColor(netHex: 0x007AFF).highlighted, for: .highlighted)
            $0.setTitle(R.string.localizable.transactionListPageNetworkError.key.localized(), for: .normal)
        }

        view.addLayoutGuide(layoutGuide)
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)

        layoutGuide.snp.makeConstraints { (m) in
            m.centerY.equalTo(view)
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
        }

        imageView.snp.makeConstraints { (m) in
            m.top.centerX.equalTo(layoutGuide)
        }

        label.snp.makeConstraints { (m) in
            m.top.equalTo(imageView.snp.bottom).offset(20)
            m.left.right.equalTo(layoutGuide)
        }

        button.snp.makeConstraints { (m) in
            m.top.equalTo(label.snp.bottom).offset(20)
            m.left.right.bottom.equalTo(layoutGuide)
        }

        button.rx.tap.bind { [weak self] in
            self?.dataStatus = .loading
            retry()
        }.disposed(by: rx.disposeBag)
        return view
    }

    func emptyView() -> UIView {
        let view = UIView()
        let layoutGuide = UILayoutGuide()
        let imageView = UIImageView(image: R.image.empty())
        let button = UIButton(type: .system).then {
            $0.isUserInteractionEnabled = false
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
            $0.setTitleColor(UIColor(netHex: 0x007AFF).highlighted, for: .highlighted)
            $0.setTitle(R.string.localizable.transactionListPageEmpty.key.localized(), for: .normal)
        }

        view.addLayoutGuide(layoutGuide)
        view.addSubview(imageView)
        view.addSubview(button)

        layoutGuide.snp.makeConstraints { (m) in
            m.center.equalTo(view)
        }

        imageView.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(layoutGuide)
        }

        button.snp.makeConstraints { (m) in
            m.top.equalTo(imageView.snp.bottom).offset(20)
            m.left.right.bottom.equalTo(layoutGuide)
        }

        return view
    }
}
