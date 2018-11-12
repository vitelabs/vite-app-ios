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

    var voteError = Variable<(String?, Error?)>((nil, nil))

    var voteSuccess = PublishSubject<Void>()

    var status = Variable<VoteStatus>(.voteInvalid)

    init() {
        vote.asObservable().skip(1).bind {
            self.vote(nodeName: $0)
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

                Observable<Int>.interval(30, scheduler: MainScheduler.instance)
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

        let statusChanged = NotificationCenter.default.rx.notification(.userVoteInfoChange)
            .map { notification -> (VoteStatus, VoteInfo) in
                let info = notification.object as! [String: Any]
                return (info["voteStatus"] as! VoteStatus, info["voteInfo"] as! VoteInfo)
            }
            .distinctUntilChanged({ $0.0 != $1.0 || $0.1.nodeName != $0.1.nodeName })

        let fetch = statusChanged
            .flatMapLatest({ (_, _)  in
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
                })
            })

        statusChanged.bind {
            self.status.value = $0.0
        }
        .disposed(by: bag)

        return Observable.combineLatest(Observable.merge([polling, fetch]), self.search.asObservable())
            .map { [unowned self] (candidates, world) in
                return self.search(candidates: candidates, world: world)
            }.share()
    }

    func search(candidates: [Candidate], world: String?) -> [Candidate] {
        var result = candidates
        if let world = world, !world.isEmpty {
            result = []
            for candidate in candidates where candidate.name.contains(world) || candidate.nodeAddr.description.contains(world) {
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

    func vote(nodeName: String) {
        guard let bag = HDWalletManager.instance.bag else { return }
        Provider.instance.vote(bag: bag, benefitedNodeName: nodeName) { result in
            if case .success = result {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userDidVote, object: nodeName)
                }
                self.voteSuccess.onNext(Void())
            } else if case let .error(error) = result {
                self.voteError.value = (nodeName, error)
            }
        }
    }

    func voteWithPow(nodeName: String, completion: @escaping (NetworkResult<Void>) -> Void) {
        guard let bag = HDWalletManager.instance.bag else { return }
        Provider.instance.voteWithPow(bag: bag, benefitedNodeName: nodeName) { result in
            if case .success = result {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userDidVote, object: nodeName)
                }
                self.voteSuccess.onNext(Void())
            } else if case let .error(error) = result {
                self.voteError.value = (nodeName, error)
            }
            completion(result)
        }
    }

}
