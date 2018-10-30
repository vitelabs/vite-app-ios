//
//  PledgeHistoryViewReactor.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/29.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import Alamofire

final class PledgeHistoryViewReactor: Reactor {

    enum Action {
        case refresh
        case loadMore
    }

    enum Mutation {
        case setLoading(Bool)
        case append(pledge: [Pledge]?, errorMessage: String?)
        case replace(pledge: [Pledge]?, errorMessage: String?)

    }

    struct State {
        var pledges: [Pledge]
        var finisheLoading: Bool
        var noMoreData: Bool
        var errorMessage: String?
    }

    var initialState: State

    init() {
        self.initialState = State.init(pledges: [], finisheLoading: true, noMoreData: false, errorMessage: nil)
    }

    func mutate(action: Action) -> Observable<Mutation> {

        switch action {
        case .refresh:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.load(refresh: true).map { Mutation.replace(pledge: $0.0, errorMessage: $0.1) },
                Observable.just(Mutation.setLoading(false)),
                ])
        case .loadMore:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.load(refresh: false).map { Mutation.append(pledge: $0.0, errorMessage: $0.1) },
                Observable.just(Mutation.setLoading(false)),
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.errorMessage = nil
        switch mutation {
        case .setLoading(let loading):
            newState.finisheLoading = !loading
        case let .append(pledge: newPledges, errorMessage: message):
            if let newPledges = newPledges {
                newState.noMoreData = newPledges.isEmpty
                newState.pledges += newPledges
            } else {
                newState.errorMessage = message
                newState.noMoreData = true
            }
        case let .replace(pledge: newPledges, errorMessage: message):
            if let newPledges = newPledges {
                newState.noMoreData = newPledges.isEmpty
                newState.pledges = newPledges
            } else {
                newState.errorMessage = message
                newState.noMoreData = true
            }
        }
        return newState
    }

    let address = HDWalletManager.instance.bag?.address ?? Address()
    var index = 0

    func load(refresh: Bool) -> Observable<([Pledge]?, String? )> {

        if refresh { index = 0 }

        return Observable<([Pledge]?, String?)>.create({ (observer) -> Disposable in
            Provider.instance.getPledges(address: self.address, index: self.index, count: 50, completion: {[weak self] (result) in
                switch result {
                case .success(let pledges):
                    self?.index += 1
                    observer.onNext((pledges, nil))
                    observer.onCompleted()
                case .error(let error):
                    observer.onNext((nil, error.message))
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }

}
