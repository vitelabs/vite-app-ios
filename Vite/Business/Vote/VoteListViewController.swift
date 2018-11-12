//
//  VoteListViewController.swift
//  Vite
//
//  Created by Water on 2018/11/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import RxDataSources

class VoteListViewController: BaseViewController {

    let reactor = VoteListReactor()

    let tableView = UITableView()

    let searchBar = SearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupUI() {

        let titleLabel = UILabel()
        titleLabel.text = R.string.localizable.voteListTitle.key.localized()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = UIColor.init(netHex: 0x3e4a59)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.left.equalToSuperview().offset(24)
        }

        view.addSubview(searchBar)

        searchBar.placeholder = R.string.localizable.voteListSearch.key.localized()

        searchBar.snp.makeConstraints { (m) in
            m.left.equalToSuperview().offset(10)
            m.top.equalTo(titleLabel.snp.bottom).offset(14)
            m.right.equalToSuperview().offset(-10)
            m.height.equalTo(36+16)
        }

        view.addSubview(tableView)

        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 100

        tableView.snp.makeConstraints { (m) in
            m.left.right.bottom.equalToSuperview()
            m.top.equalTo(searchBar.snp.bottom).offset(10)
        }

        tableView.register(CandidateCell.self, forCellReuseIdentifier: "Cell")
    }

    func bind() {

        searchBar.rx.text
            .bind(to: reactor.search)
            .disposed(by: rx.disposeBag)

        let result = reactor.result()

        self.view.displayLoading()
        result
            .map { $0.isEmpty }
            .filter { !$0 }
            .take(1)
            .bind { _ in
                self.view.hideLoading()
            }
            .disposed(by: rx.disposeBag)

        result
            .map { $0.isEmpty }
            .bind {
                print($0)
            }
            .disposed(by: rx.disposeBag)

        result
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { [unowned self] _, candidate, cell in
               let cell = cell as! CandidateCell
                cell.nodeNameLabel.text = candidate.name
                cell.voteCountLabel.text = candidate.voteNum
                cell.addressLabel.text = " " + candidate.nodeAddr
                cell.disposeable?.dispose()
                cell.disposeable = cell.voteButton.rx.tap.bind {
                    self.vote(nodeName: candidate.name)
                }
                cell.disposeable?.disposed(by: cell.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)

        reactor.voteError.asObservable()
            .filterNil()
            .bind { error in
                if !BussinessErrorHandler.hander(error: error, in: self) {
                    Toast.show(error.message)
                }
            }
            .disposed(by: rx.disposeBag)
    }

    var status = false

    func vote(nodeName: String) {

        func confirmVote() {
            let confirmVC = ConfirmTransactionViewController.comfirmVote(title: R.string.localizable.vote.key.localized(),
                                                                         nodeName: nodeName) { [unowned self] (result) in
                switch result {
                case .success:
                    self.reactor.vote.value = nodeName
                default:
                    break
                }
            }
            self.present(confirmVC, animated: false, completion: nil)
        }

        if status {
            confirmVote()
        } else {
            Alert.show(into: self,
                       title: R.string.localizable.vote.key.localized(),
                       message: R.string.localizable.voteListAlertMessage.key.localized(),
                       actions: [
                        (.default(title:R.string.localizable.voteListConfirmRevote.key.localized()), {  _ in
                            confirmVote()
                       }),
                        (.default(title:  R.string.localizable.cancel.key.localized()), {  _ in
                            self.dismiss(animated: false, completion: nil)
                       })])

            return
        }
    }

}
