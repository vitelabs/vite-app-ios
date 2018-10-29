//
//  HistoryViewController.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import ReactorKit
import MJRefresh

class PledgeHistoryViewController: BaseViewController, View {

    var disposeBag = DisposeBag()

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationTitleView = NavigationTitleView.init(title: R.string.localizable.peldgeTitle.key.localized(), style: .default)
        view.addSubview(navigationTitleView)
        navigationTitleView.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuideSnpTop)
            m.left.equalTo(view)
            m.right.equalTo(view)
        }

        let descriptionView = PledgeHistoryDescriptionView()
        view.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { (m) in
            m.top.equalTo(navigationTitleView.snp.bottom).offset(12)
            m.left.equalTo(self.view).offset(12)
            m.right.equalTo(self.view).offset(-12)
            m.height.equalTo(80)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.left.bottom.right.equalTo(view)
            m.top.equalTo(descriptionView.snp.bottom).offset(12)
        }
        tableView.rowHeight = 72
        tableView.register(PledgeHistoryCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorColor = UIColor.init(netHex: 0xD3DFEF)
        tableView.tableFooterView = UIView()
        tableView.mj_header.beginRefreshing()
    }

    func bind(reactor: PledgeHistoryViewReactor) {

        tableView.mj_header = RefreshHeader(refreshingBlock: { [weak reactor] in
            reactor?.action.onNext(.refresh)
        })

        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak reactor] in
            reactor?.action.onNext(.loadMore)
        })

        reactor.state
            .map { $0.pledges }
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, pledge, cell in
                let cell = cell as! PledgeHistoryCell
                cell.hashLabel.text = pledge.beneficialAddress.description
                cell.timeLabel.text = pledge.timestamp.format() + R.string.localizable.peldgeDeadline.key.localized()
                cell.balanceLabel.text =  pledge.amount.amountShort(decimals: TokenCacheService.instance.viteToken.decimals)
                cell.symbolLabel.text = "VITE"
            }
            .disposed(by: disposeBag)

        reactor.state
            .distinctUntilChanged { $0.finisheLoading != $1.finisheLoading }
            .filter { $0.finisheLoading }
            .bind { [unowned self] _ in
                if self.tableView.mj_header.isRefreshing {
                    self.tableView.mj_header.endRefreshing()
                }
                if self.tableView.mj_footer.isRefreshing {
                    self.tableView.mj_footer.endRefreshing()
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.noMoreData }
            .bind { [unowned self] in
                self.tableView.mj_footer.state = $0 ? .noMoreData : .idle
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.errorMessage }
            .filterNil()
            .bind { Toast.show($0) }
            .disposed(by: disposeBag)

    }
}
