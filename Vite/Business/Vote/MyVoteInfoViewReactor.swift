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
import NSObject_Rx

final class MyVoteInfoViewReactor: Reactor {
    let address = HDWalletManager.instance.bag?.address ?? Address()
    let bag = HDWalletManager.instance.bag ??  HDWalletManager.Bag()
    var disposeBag = DisposeBag()

    enum Action {
        case refreshData
        case cancelVote
//        case voting
//        case loading
    }

    enum Mutation {
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
        _ = NotificationCenter.default.rx.notification(.userDidVote).subscribe(onNext: { [unowned self] (value) in
    
        })

    }

    func mutate(action: Action) -> Observable<Mutation> {

        switch action {
        case .refreshData:
            return Observable.concat([
                self.fetchVoteInfo().map { Mutation.replace(voteInfo: $0.0, errorMessage: $0.1) },
                ])

        case .cancelVote:
            return Observable.concat([
                self.fetchVoteInfo().map { Mutation.replace(voteInfo: $0.0, errorMessage: $0.1) },
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.errorMessage = nil
        switch mutation {
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

    func fetchVoteInfo() -> Observable<(VoteInfo?, String? )> {
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
            ) { (result) in
                switch result {
                case .success:
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
