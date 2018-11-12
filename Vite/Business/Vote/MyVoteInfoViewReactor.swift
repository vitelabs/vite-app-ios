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
        case voting(String)
//        case voting
//        case loading
    }

    enum Mutation {
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
        case .refreshData((let address)):
            return Observable.concat([
                self.fetchVoteInfo(address).map { Mutation.replace(voteInfo: $0.0, errorMessage: $0.1) },
                ])
        case .cancelVote:
            return Observable.concat([
                self.createLocalVoteInfo("",false).map { Mutation.replace(voteInfo: $0.0, errorMessage: nil) },
                ])
        case .voting(let nodeName):
            return Observable.concat([
                self.createLocalVoteInfo(nodeName,false).map { Mutation.replace(voteInfo: $0.0, errorMessage: nil) },
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.errorMessage = nil
        switch mutation {
        case let .replace(voteInfo: voteInfo, errorMessage: message):
                newState.voteInfo = voteInfo
                newState.errorMessage = message
                newState.dataIsFromServer = true
        }
        return newState
    }

    func createLocalVoteInfo(_ nodeName:String,_ isCancel:Bool)-> Observable<(VoteInfo, VoteStatus)> {
        return Observable<(VoteInfo, VoteStatus)>.create({ (observer) ->
            Disposable in
//            var voteInfo = VoteInfo(nodeName,.valid,)
//            voteInfo.nodeName = nodeName
//            observer.onNext((voteInfo, isCancel ? .cancelVoting : .voting))
//            observer.onCompleted()
            return Disposables.create()
        })
    }
    func fetchVoteInfo(_ address : String) -> Observable<(VoteInfo?, String? )> {
        return Observable<(VoteInfo?, String?)>.create({ (observer) -> Disposable in
            Provider.instance.getVoteInfo(address: address
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
