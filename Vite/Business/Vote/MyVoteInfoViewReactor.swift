//
//  MyVoteInfoViewReactor.swift
//  Vite
//
//  Created by Water on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import Alamofire

final class MyVoteInfoViewReactor: Reactor {
    let address = HDWalletManager.instance.bag?.address ?? Address()
    let bag = HDWalletManager.instance.bag ??  HDWalletManager.Bag()

    enum Action {
        case refreshData
        case cancelVote
//        case voting
//        case loading
    }

    enum Mutation {
        case setLoading(Bool)
        case append(voteInfo: VoteInfo?, errorMessage: String?)
        case replace(voteInfo: VoteInfo?, errorMessage: String?)
    }

    struct State {
        var voteInfo: VoteInfo?
        var dataIsFromServer: Bool
        var errorMessage: String?
    }

    var initialState: State

    init() {
        self.initialState = State.init(voteInfo: nil, dataIsFromServer: false, errorMessage: nil)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshData:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.fetchVoteInfo(refresh: true).map { Mutation.replace(voteInfo: $0.0, errorMessage: $0.1) },
                Observable.just(Mutation.setLoading(false)),
                ])
        case .cancelVote:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.fetchVoteInfo(refresh: false).map { Mutation.append(voteInfo: $0.0, errorMessage: $0.1) },
                Observable.just(Mutation.setLoading(false)),
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.errorMessage = nil
        switch mutation {
        case .setLoading(let loading):
            newState.dataIsFromServer = !loading
        case let .append(voteInfo: voteInfo, errorMessage: message):
            if let voteInfo = voteInfo {
                newState.voteInfo = voteInfo
            } else {
                newState.errorMessage = message
                newState.dataIsFromServer = true
            }
        case let .replace(voteInfo: voteInfo, errorMessage: message):
            if let voteInfo = voteInfo {
                newState.voteInfo = voteInfo
            } else {
                newState.errorMessage = message
                newState.dataIsFromServer = true
            }
        }
        return newState
    }

    func fetchVoteInfo(refresh: Bool) -> Observable<(VoteInfo?, String? )> {

        if refresh { }

        return Observable<(VoteInfo?, String?)>.create({ (observer) -> Disposable in
            Provider.instance.getVoteInfo(address: self.address
            ) { (result) in
                switch result {
                case .success(let voteInfo):
                    observer.onNext((voteInfo, nil))
                    observer.onCompleted()
                case .error(let error):
                    observer.onNext((nil, error.message))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }

    func cancelVoteAndSendWithoutGetPow()-> Observable<(String? )> {
        return Observable<(String?)>.create({ (observer) -> Disposable in
            Provider.instance.cancelVoteAndSendWithoutGetPow(bag: self.bag
            ) { [weak self] (result) in
                switch result {
                case .success(let str):
                    //                    guard let voteInfo = voteInfo else {
                    //                        self?.viewInfoView.isHidden = true
                    //                        return
                    //                    }
                    observer.onNext(nil)
                    observer.onCompleted()
                case .error(let error):
                    observer.onNext(error.message)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }

}
