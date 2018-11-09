//
//  VoteListReactor.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import APIKit

final class VoteListReactor {

    let search = Variable<String?>("")

    let vote = Variable<String>("")

    let bag = DisposeBag()

    var voteError = Variable<Error?>(nil)

    init() {
        vote.asObservable().skip(1).bind {
            self.vote(nodeName: $0, completion: { _ in })
        }.disposed(by: bag)
    }

    func result() -> Observable<[Candidate]> {
        let polling = Observable.concat([
                Observable<[Candidate]>.create({ (observer) -> Disposable in
                    _ = Provider.instance.getCandidateList { result in
                        switch result {
                        case .success(let candidates):
                            observer.onNext(candidates)
                            observer.onCompleted()
                        case .error:
                            observer.onCompleted()
                        }
                    }
                    return Disposables.create()
                }),

                Observable<Int>.interval(10, scheduler: MainScheduler.instance)
                .flatMap { _ in
                    Observable<[Candidate]>.create({ (observer) -> Disposable in
                        _ = Provider.instance.getCandidateList { result in
                            switch result {
                            case .success(let candidates):
                                observer.onNext(candidates)
                            case .error:
                                break
                            }
                        }
                        return Disposables.create()
                    })
                }
        ])

        return Observable.combineLatest(polling, self.search.asObservable())
            .map { [unowned self] (candidates, world) in
                return self.search(candidates: candidates, world: world)
            }.share()
    }

    func search(candidates: [Candidate], world: String?) -> [Candidate] {
        var result = candidates
        if let world = world, !world.isEmpty {
            result = []
            for candidate in candidates where candidate.name.contains(world) || candidate.nodeAddr.contains(world) {
                result.append(candidate)
            }
        }
        return result.sorted(by: {
            if let n0 = Int($0.voteNum), let n1 = Int($1.voteNum) {
                return n0 > n1
            }
            return $0.voteNum > $1.voteNum
        })
    }

    func vote(nodeName: String, completion: @escaping (NetworkResult<Void>) -> Void) {
        guard let bag = HDWalletManager.instance.bag else { return }
        Provider.instance.vote(bag: bag, benefitedNodeName: nodeName) { result in
            if case .success = result {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userDidVote, object: nodeName)
                }
            } else if case let .error(error) = result {
                self.voteError.value = error
            }
            completion(result)
        }
    }

}
