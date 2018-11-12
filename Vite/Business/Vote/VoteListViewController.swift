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
import NSObject_Rx
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

        typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Candidate>>
        let dataSource = DataSource(configureCell: { (_, tableView, indexPath, candidate) -> UITableViewCell in
            let cell: CandidateCell = tableView.dequeueReusableCell(for: indexPath)
            cell.nodeNameLabel.text = candidate.name
            cell.voteCountLabel.text = candidate.voteNum
            cell.addressLabel.text = " " + candidate.nodeAddr.description
            cell.disposeable?.dispose()
            cell.disposeable = cell.voteButton.rx.tap
                .bind {
                self.vote(nodeName: candidate.name)
                }
            cell.disposeable?.disposed(by: cell.rx.disposeBag)
            return cell
        })

        result
            .map { config -> [SectionModel<String, Candidate>] in
                return [SectionModel(model: "item", items: config)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        self.tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let `self` = self else { fatalError() }
                if let item = (try? dataSource.model(at: indexPath)) as? Candidate {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    WebHandler.openAddressDetailPage(address: item.nodeAddr.description)
                }
            }
            .disposed(by: rx.disposeBag)

        reactor.voteError.asObservable()
            .filter { $0.0 != nil && $0.1 != nil }
            .bind { [unowned self] in
                self.handler(error: $0.1!, nodeName: $0.0!)
            }
            .disposed(by: rx.disposeBag)

        reactor.voteSuccess.asObserver()
            .bind { _ in
                Toast.show(R.string.localizable.voteListSendSuccess.key.localized())
            }
            .disposed(by: rx.disposeBag)

        Observable.merge([
            NotificationCenter.default.rx.notification(.UIKeyboardWillHide),
            NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
            ])
            .filter { [unowned self] _  in self.appear }
            .subscribe(onNext: {[weak self] (notification) in
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                let height =  min((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height, 128+55)
                UIView.animate(withDuration: duration, animations: {
                    if notification.name == .UIKeyboardWillShow {
                        self?.parent?.view.transform = CGAffineTransform(translationX: 0, y: -height)
                    } else {
                        self?.parent?.view.transform = .identity
                    }
                })
            }).disposed(by: rx.disposeBag)
    }

    var status = false

    func vote(nodeName: String) {

        let voted = self.reactor.status.value == .voteSuccess || self.reactor.status.value == .voteSuccess

        if !voted {
            self.confirmVote(nodeName: nodeName)
        } else {
            Alert.show(into: self,
                       title: R.string.localizable.vote.key.localized(),
                       message: R.string.localizable.voteListAlertAlreadyVoted.key.localized(),
                       actions: [
                        (.default(title:R.string.localizable.voteListConfirmRevote.key.localized()), { [unowned self] _ in
                            self.confirmVote(nodeName: nodeName)
                       }),
                        (.default(title:  R.string.localizable.cancel.key.localized()), {  _ in
                            self.dismiss(animated: false, completion: nil)
                       })])
        }
    }

    func confirmVote(nodeName: String) {
        let confirmVC = ConfirmViewController.comfirmVote(title: R.string.localizable.vote.key.localized(),
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

    func handler(error: Error, nodeName: String) {
        if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
            Alert.show(into: self,
                       title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle.key.localized(),
                       message: nil,
                       actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton.key.localized()), nil)])
        } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
            Alert.show(into: self, title: R.string.localizable.quotaAlertTitle.key.localized(), message: R.string.localizable.voteListAlertQuota.key.localized(), actions: [
                (.default(title: R.string.localizable.quotaAlertQuotaButtonTitle.key.localized()), { [weak self] _ in
                    let vc = QuotaManageViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                (.default(title: R.string.localizable.quotaAlertPowButtonTitle.key.localized()), { [weak self] _ in
                    self?.view.displayLoading()
                    self?.reactor.voteWithPow(nodeName: nodeName, completion: { (_) in
                        self?.view.hideLoading()
                    })
                }),
                (.cancel, nil),
                ], config: { alert in
                    alert.preferredAction = alert.actions[0]
            })
        } else {
             Toast.show(R.string.localizable.voteListSendFailed.key.localized())
        }
    }

    var appear = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appear = false
    }

}
