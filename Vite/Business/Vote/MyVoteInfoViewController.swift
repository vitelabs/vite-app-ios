//
//  MyVoteInfoViewController.swift
//  Vite
//
//  Created by Water on 2018/11/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import BigInt
import RxSwift
import ReactorKit
import RxDataSources
import ViteUtils

class MyVoteInfoViewController: BaseViewController, View {
    // FIXME: Optional
    let bag = HDWalletManager.instance.bag!
    var disposeBag = DisposeBag()
    var balance: Balance?
    var oldVoteInfo: VoteInfo?

    init() {
        super.init(nibName: nil, bundle: nil)
        self.reactor = MyVoteInfoViewReactor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupView()
        self._bindView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._pollingInfoData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GCD.cancel(self.reactor?.pollingVoteInfoTask)
    }

    private func _pollingInfoData () {
        self.reactor?.action.onNext(.refreshData(HDWalletManager.instance.bag?.address.description ?? ""))

    }

    private func _bindView() {
        //home page vite balance
        FetchBalanceInfoService.instance.balanceInfosDriver.drive(onNext: { [weak self] balanceInfos in
            guard let `self` = self else { return }
            for balanceInfo in balanceInfos where TokenCacheService.instance.viteToken.id == balanceInfo.token.id {
                self.balance = balanceInfo.balance
                return
            }
            if self.viewInfoView.voteStatus == .voting {
                // no balanceInfo, set 0.0
                self.viewInfoView.nodePollsLab.text = "0.0"
            }
        }).disposed(by: rx.disposeBag)

        //change address
        HDWalletManager.instance.bagDriver.drive(onNext: { [weak self] _ in
            self?.viewInfoView.resetView()
            self?.viewInfoView.isHidden = true
            self?.voteInfoEmptyView.isHidden = false
        }).disposed(by: disposeBag)

        self.viewInfoView.nodeStatusLab.tipButton.rx.tap.bind {
            let url  = URL(string: String(format: "%@?localize=%@&nodeName=%@", Constants.voteLoserURL, LocalizationService.sharedInstance.currentLanguage.rawValue, self.viewInfoView.voteInfo?.nodeName ?? ""))!
            let vc = PopViewController(url: url)
            vc.modalPresentationStyle = .overCurrentContext
            let delegate =  StyleActionSheetTranstionDelegate()
            vc.transitioningDelegate = delegate
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }.disposed(by: rx.disposeBag)

        //handle cancel vote
        self.viewInfoView.operationBtn.rx.tap.bind {[weak self] _ in
            self?.cancelVoteAction()
        }.disposed(by: rx.disposeBag)

        //vote success
        _ = NotificationCenter.default.rx.notification(.userDidVote).takeUntil(self.rx.deallocated).observeOn(MainScheduler.instance).subscribe({[weak self] (notification)   in
            let nodeName = notification.element?.object
            self?.reactor?.action.onNext(.voting(nodeName as! String, self?.balance))
        })
    }

    private func _setupView() {
        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        view.backgroundColor = .clear

        view.addSubview(self.viewInfoView)
        self.viewInfoView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        view.addSubview(self.voteInfoEmptyView)
        self.voteInfoEmptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        self.viewInfoView.isHidden = true
        self.voteInfoEmptyView.isHidden = false
    }

    lazy var viewInfoView: VoteInfoView = {
        let viewInfoView = VoteInfoView()
        return viewInfoView
    }()

    lazy var voteInfoEmptyView: VoteInfoEmptyView = {
        let voteInfoEmptyView = VoteInfoEmptyView()
        return voteInfoEmptyView
    }()
}

extension MyVoteInfoViewController {
    private func refreshVoteInfoView(_ voteInfo: VoteInfo, _ voteStatus: VoteStatus) {
        UIView.animate(withDuration: 0.3) {
            self.viewInfoView.isHidden = false
            self.voteInfoEmptyView.isHidden = true
        }
        self.viewInfoView.reloadData(voteInfo, voteInfo.nodeStatus == .invalid ? .voteInvalid :voteStatus)

        self.notificationList(voteInfo, voteStatus)
    }

    private func notificationList(_ voteInfo: VoteInfo?, _ voteStatus: VoteStatus) {
        var status = voteStatus
        if voteInfo?.nodeStatus == .invalid {
            status = .voteInvalid
        }
        NotificationCenter.default.post(name: .userVoteInfoChange, object: ["voteInfo": voteInfo ?? VoteInfo(), "voteStatus": status])
        plog(level: .info, log: String.init(format: " voteStatus = %d voteInfo.nodeName  = %@", status.rawValue, voteInfo?.nodeName ?? ""), tag: .vote)
    }

    func bind(reactor: MyVoteInfoViewReactor) {
        //handle new vote data coming
        reactor.state
            .map { ($0.voteInfo, $0.voteStatus, $0.error) }
            .bind {[weak self] in
                guard let voteStatus = $1 else {
                    return
                }
                guard let error = $2 else {
                    //handle cancel vote
                    if voteStatus == .cancelVoting {
                        self?.viewInfoView.changeInfoCancelVoting()
                        HUD.hide()
                        Toast.show(R.string.localizable.votePageVoteInfoCancelVoteToastTitle())
                        return
                    }

                    guard let voteInfo = $0 else {
                        //voteInfo == nil && old voteStatus = voting
                        if self?.viewInfoView.voteStatus != .voting {
                            UIView.animate(withDuration: 0.3, animations: {
                                self?.viewInfoView.isHidden = true
                                self?.voteInfoEmptyView.isHidden = false
                            })
                        }
                        self?.notificationList(nil, .noVote)
                        return
                    }
                    //server node can't affirm
                    if self?.oldVoteInfo?.nodeName == voteInfo.nodeName &&
                        (self?.viewInfoView.voteStatus == .voting || self?.viewInfoView.voteStatus == .cancelVoting) {
                        return
                    }
                    //voteInfo != nil && new voteStatus = voting, old  voteInfo
                    if voteStatus != .voting && voteStatus != .cancelVoting {
                        self?.oldVoteInfo = voteInfo
                    }

                    self?.refreshVoteInfoView(voteInfo, voteStatus)
                    return
                }

                //cancel voting handle error
                if voteStatus == .cancelVoting {
                    DispatchQueue.main.async {
                        self?.handlerCancelError(error)
                    }
                }
            }.disposed(by: disposeBag)
    }
}

extension MyVoteInfoViewController {
    private func cancelVoteAction() {
         DispatchQueue.main.async {
            let confirmVC = ConfirmTransactionViewController.comfirmVote(title: R.string.localizable.votePageVoteInfoCancelVoteTitle(),
                                                                         nodeName: self.viewInfoView.voteInfo?.nodeName ?? "") { [unowned self] (result) in
                                                                            switch result {
                                                                            case .success:
                                                                                    HUD.show()
                                                                                    self.reactor?.action.onNext(.cancelVoteWithoutGetPow)
                                                                            case .cancelled:
                                                                                plog(level: .info, log: "Confirm vote cancel cancelled", tag: .vote)
                                                                            case .biometryAuthFailed:
                                                                                Alert.show(into: self,
                                                                                           title: R.string.localizable.sendPageConfirmBiometryAuthFailedTitle(),
                                                                                           message: nil,
                                                                                           actions: [(.default(title: R.string.localizable.sendPageConfirmBiometryAuthFailedBack()), nil)])
                                                                            case .passwordAuthFailed:
                                                                                Alert.show(into: self,
                                                                                           title: R.string.localizable.confirmTransactionPageToastPasswordError(),
                                                                                           message: nil,
                                                                                           actions: [(.default(title: R.string.localizable.sendPageConfirmPasswordAuthFailedRetry()), { [unowned self] _ in
                                                                                            self.cancelVoteAction()
                                                                                           }), (.cancel, nil)])
                                                                            }
            }
            self.present(confirmVC, animated: false, completion: nil)
         }
    }

    private func handlerCancelError(_ error: Error) {
        HUD.hide()
        if error.code == ViteErrorCode.rpcNotEnoughBalance {
            AlertSheet.show(into: self,
                            title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle(),
                            message: nil,
                            actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton()), nil)])
        } else if error.code == ViteErrorCode.rpcNotEnoughQuota {
            AlertSheet.show(into: self, title: R.string.localizable.quotaAlertTitle(), message: R.string.localizable.votePageVoteInfoAlertQuota(), actions: [
                (.default(title: R.string.localizable.quotaAlertPowButtonTitle()), { [weak self] _ in
                    var cancelPow = false
                    let getPowFloatView = GetPowFloatView(superview: UIApplication.shared.keyWindow!) {
                        cancelPow = true
                    }
                    getPowFloatView.show()

                    //get pow data
                    self?.reactor?.cancelVoteAndSendWithGetPow(completion: { (result) in
                        guard cancelPow == false else { return }
                        guard let `self` = self else { return }
                        if case let .success(context) = result {
                            getPowFloatView.finish(completion: {
                                //send transaction
                                HUD.show()
                                self.reactor?.cancelVoteSendTransaction(context, completion: { (result) in
                                    HUD.hide()
                                    if case .success = result {
                                        //in the end
                                        self.viewInfoView.changeInfoCancelVoting()
                                        Toast.show(R.string.localizable.votePageVoteInfoCancelVoteToastTitle())
                                    } else if case let .failure(error) = result {
                                           Toast.show(error.message)
                                    }
                                })
                            })
                        } else if case let .failure(error) = result {
                            getPowFloatView.hide()
                            Toast.show(error.message)
                        }
                    })
                }),
                (.default(title: R.string.localizable.quotaAlertQuotaButtonTitle()), { [weak self] _ in
                    let vc = QuotaManageViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                (.cancel, nil),
                ], config: { alert in
                    alert.preferredAction = alert.actions[0]
            })
        } else {
            Toast.show(error.message)
        }
    }
}
