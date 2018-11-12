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

    let bag = HDWalletManager.instance.bag ??  HDWalletManager.Bag()
    var disposeBag = DisposeBag()

    enum Action {
        case refreshData(String)
        case cancelVote
        case voting(String, Balance?)
    }

    enum Mutation {
        case replace(voteInfo: VoteInfo?, voteStatus: VoteStatus?, error: Error?)
    }

    struct State {
        var voteInfo: VoteInfo?
        var voteStatus: VoteStatus?
        var error: Error?
    }

    var initialState: State

    init() {
        self.initialState = State.init(voteInfo: nil, voteStatus: nil, error: nil)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshData((let address)):
            return Observable.concat([
                self.fetchVoteInfo(address).map { Mutation.replace(voteInfo: $0.0, voteStatus: .voteSuccess, error: nil) },
                ])
        case .cancelVote:
            return Observable.concat([
                self.cancelVoteAndSendWithoutGetPow().map({
                 Mutation.replace(voteInfo: nil, voteStatus: .cancelVoting, error: $0)
                })
                ])
        case .voting(let nodeName, let banlance):
            return Observable.concat([
                self.createLocalVoteInfo(nodeName, banlance, false).map { Mutation.replace(voteInfo: $0.0, voteStatus: .voting, error: nil) },
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.error = nil
        switch mutation {
        case let .replace(voteInfo: voteInfo, voteStatus: voteStatus, error: message):
                newState.voteInfo = voteInfo
                newState.error = message
                newState.voteStatus = voteStatus
        }
        return newState
    }

    func createLocalVoteInfo(_ nodeName: String, _ balance: Balance?, _ isCancel: Bool)-> Observable<(VoteInfo, VoteStatus)> {
        return Observable<(VoteInfo, VoteStatus)>.create({ (observer) ->
            Disposable in
            let voteInfo = VoteInfo(nodeName, .valid, balance)
            observer.onNext((voteInfo, isCancel ? .cancelVoting : .voting))
            observer.onCompleted()
            return Disposables.create()
        })
    }

    func fetchVoteInfo(_ address: String) -> Observable<(VoteInfo?, Error? )> {
        return Observable<(VoteInfo?, Error?)>.create({ (observer) -> Disposable in
            Provider.instance.getVoteInfo(address: address
            ) { (result) in
                switch result {
                case .success(let voteInfo):
                    observer.onNext((voteInfo, nil))
                    observer.onCompleted()
                case .error(let error):
                    observer.onNext((nil, error))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }

    func cancelVoteAndSendWithoutGetPow()-> Observable<(Error? )> {
        return Observable<(Error?)>.create({ (observer) -> Disposable in
            Provider.instance.cancelVoteAndSendWithoutGetPow(bag: self.bag
            ) { (result) in
                switch result {
                case .success:
                    observer.onNext(nil)
                    observer.onCompleted()
                case .error(let error):
                    observer.onNext(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }

    func cancelVoteAndSendWithGetPow(completion: @escaping (NetworkResult<Void>) -> Void) {
            Provider.instance.cancelVoteAndSendWithGetPow(bag: self.bag
            ) { (result) in
//                switch result {
//                case .success:
//                    observer.onNext(nil)
//                    observer.onCompleted()
//                case .error(let error):
//                    observer.onNext(error)
//                    observer.onCompleted()
//                }
                completion(result)
            }
        }
}
