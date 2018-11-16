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
            .filterNil()
            .map { $0.isEmpty }
            .filter { !$0 }
            .take(1)
            .bind { _ in
                self.view.hideLoading()
            }
            .disposed(by: rx.disposeBag)

        result
            .filterNil()
            .map { $0.isEmpty }
            .filter { $0 }
            .bind { [unowned self]_ in
                if let text = self.searchBar.textField.text, !text.isEmpty {
                    Toast.show(R.string.localizable.voteListSearchEmpty.key.localized())
                }
            }
            .disposed(by: rx.disposeBag)

        typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Candidate>>
        let dataSource = DataSource(configureCell: { (_, tableView, indexPath, candidate) -> UITableViewCell in
            let cell: CandidateCell = tableView.dequeueReusableCell(for: indexPath)
            cell.nodeNameLabel.text = candidate.name
            cell.voteCountLabel.text = candidate.voteNum.amountShort(decimals: TokenCacheService.instance.viteToken.decimals)
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
            .filterNil()
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
                self.view.hideLoading()
                self.handler(error: $0.1!, nodeName: $0.0!)
            }
            .disposed(by: rx.disposeBag)

        reactor.voteSuccess.asObserver()
            .bind { [unowned self] _ in
                self.view.hideLoading()
                Toast.show(R.string.localizable.voteListSendSuccess.key.localized())
            }
            .disposed(by: rx.disposeBag)

        Observable.merge([
            NotificationCenter.default.rx.notification(.UIKeyboardWillHide),
            NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
            ])
            .filter { [unowned self] _  in self.appear }
            .subscribe(onNext: {[unowned self] (notification) in
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                let height =  min((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height, 128+55)
                UIView.animate(withDuration: duration, animations: {
                    if notification.name == .UIKeyboardWillShow && self.searchBar.textField.isFirstResponder {
                        self.parent?.view.transform = CGAffineTransform(translationX: 0, y: -height)
                    } else if notification.name == .UIKeyboardWillHide {
                        self.parent?.view.transform = .identity
                    }
                })
            }).disposed(by: rx.disposeBag)

        self.reactor.fetchCandidateError.asObservable()
            .filterNil()
            .takeUntil(result)
            .bind { [weak self] e in
                self?.dataStatus = .networkError(e, { [weak self] in
                    self?.dataStatus = .normal
                    self?.reactor.fetchManually.onNext(Void())
                })
                self?.view.hideLoading()
            }.disposed(by: rx.disposeBag)

        self.reactor.fetchCandidateError.asObservable()
            .filter { $0 == nil }
            .bind { [weak self] _ in
                self?.view.hideLoading()
                self?.dataStatus = .normal
            }.disposed(by: rx.disposeBag)

    }

    func vote(nodeName: String) {
        let (status, info) = self.reactor.lastVoteInfo.value
        let voted = status == .voteSuccess || status == .voting

        if !voted {
            self.confirmVote(nodeName: nodeName)
        } else {
            Alert.show(into: self,
                       title: R.string.localizable.vote.key.localized(),
                       message: R.string.localizable.voteListAlertAlreadyVoted.key.localized(arguments: info?.nodeName ?? ""),
                       actions: [
                        (.default(title:R.string.localizable.voteListConfirmRevote.key.localized()), { [unowned self] _ in
                            self.confirmVote(nodeName: nodeName)
                       }),
                        (.default(title:  R.string.localizable.cancel.key.localized()), { [unowned self] _ in
                            self.dismiss(animated: false, completion: nil)
                       })])
        }
    }

    func confirmVote(nodeName: String) {
        let confirmVC = ConfirmViewController.comfirmVote(title: R.string.localizable.vote.key.localized(),
                                                          nodeName: nodeName) { [unowned self] (result) in
                                                            switch result {
                                                            case .success:
                                                                self.view.displayLoading()
                                                                self.reactor.vote.value = nodeName
                                                            case .passwordAuthFailed:
                                                                Alert.show(into: self,
                                                                           title: R.string.localizable.confirmTransactionPageToastPasswordError.key.localized(),
                                                                           message: nil,
                                                                           actions: [(.default(title: R.string.localizable.sendPageConfirmPasswordAuthFailedRetry.key.localized()), { [unowned self] _ in
                                                                            self.confirmVote(nodeName: nodeName)
                                                                           }), (.cancel, nil)])
                                                            case .biometryAuthFailed:
                                                                Alert.show(into: self,
                                                                           title: R.string.localizable.sendPageConfirmBiometryAuthFailedTitle.key.localized(),
                                                                           message: nil,
                                                                           actions: [(.default(title: R.string.localizable.sendPageConfirmBiometryAuthFailedBack.key.localized()), nil)])
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
                (.default(title: R.string.localizable.quotaAlertPowButtonTitle.key.localized()), { [weak self] _ in
                    var cancelPow = false
                    let getPowFloatView = GetPowFloatView(superview: UIApplication.shared.keyWindow!) {
                        cancelPow = true
                    }
                    getPowFloatView.show()
                    self?.reactor.voteWithPow(nodeName: nodeName, tryToCancel: { () -> Bool in
                        return cancelPow
                    }, completion: { (_) in
                        getPowFloatView.hide()
                    })

                }),
                (.default(title: R.string.localizable.quotaAlertQuotaButtonTitle.key.localized()), { [weak self] _ in
                    let vc = QuotaManageViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                (.cancel, nil),
                ], config: { alert in
                    alert.preferredAction = alert.actions[0]
            })
        } else if error.code == Provider.TransactionErrorCode.noTransactionBefore.rawValue {
            Toast.show(R.string.localizable.voteListSearchNoTransactionBefore.key.localized())
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

extension VoteListViewController: ViewControllerDataStatusable {

    func networkErrorView(error: Error, retry: @escaping () -> Void) -> UIView {
        return UIView.defaultNetworkErrorView(error: error) { [weak self] in
            self?.view.displayLoading()
            retry()
        }
    }
}
