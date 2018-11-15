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
    let fetchManually = PublishSubject<Void>()

    var fetchCandidateError = Variable<Error?>(nil)
    var voteError = Variable<(String?, Error?)>((nil, nil))
    var voteSuccess = PublishSubject<Void>()
    var lastVoteInfo = Variable<(VoteStatus, VoteInfo?)>((.voteInvalid, nil))

    let bag = DisposeBag()

    init() {
        vote.asObservable().skip(1).bind {
            self.vote(nodeName: $0)
        }.disposed(by: bag)
    }

    func result() -> Observable<[Candidate]?> {
        let polling = Observable.concat([
                Observable<[Candidate]?>.create({ (observer) -> Disposable in
                    _ = Provider.instance.getCandidateList { [weak self] result in
                        switch result {
                        case .success(let candidates):
                            observer.onNext(candidates)
                            observer.onCompleted()
                        case .error(let error):
                            self?.fetchCandidateError.value = error
                            observer.onCompleted()
                        }
                    }
                    return Disposables.create()
                }),

                Observable<Int>.interval(30, scheduler: MainScheduler.instance)
                .flatMap { [weak self] _ in
                    Observable<[Candidate]?>.create({ (observer) -> Disposable in
                        _ = Provider.instance.getCandidateList { result in
                            switch result {
                            case .success(let candidates):
                                self?.fetchCandidateError.value = nil
                                observer.onNext(candidates)
                            case .error(let error):
                                self?.fetchCandidateError.value = error
                            }
                        }
                        return Disposables.create()
                    })
                }
        ])

        let statusChanged = NotificationCenter.default.rx.notification(.userVoteInfoChange)
            .map { notification -> (VoteStatus, VoteInfo?) in
                let info = notification.object as! [String: Any]
                return (info["voteStatus"] as! VoteStatus, info["voteInfo"] as? VoteInfo)
            }
            .distinctUntilChanged({ $0.0 == $1.0 && $0.1?.nodeName == $1.1?.nodeName })

        statusChanged.bind { self.lastVoteInfo.value = $0 }.disposed(by: bag)

        let fetchWhenStatusChange = statusChanged
            .flatMapLatest({ (_, _)  in
                Observable<[Candidate]?>.create({ (observer) -> Disposable in
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

        let fetchManually = self.fetchManually
            .flatMap({ (_)  in
                Observable<[Candidate]?>.create({ (observer) -> Disposable in
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

        let fetch = Observable.merge([fetchWhenStatusChange, fetchManually])

        return Observable.combineLatest(Observable.merge([polling, fetch]), self.search.asObservable())
            .map { [unowned self] (candidates, world) in
                return self.search(candidates: candidates, with: world)
            }.share()
    }

    func search(candidates: [Candidate]?, with world: String?) -> [Candidate]? {
        guard let candidates = candidates else {
            return nil
        }
        var result = candidates
        if let world = world?.lowercased(), !world.isEmpty {
            result = []
            for candidate in candidates where candidate.name.lowercased().contains(world) || candidate.nodeAddr.description.lowercased().contains(world) {
                result.append(candidate)
            }
        }
        return result.sorted(by: {
            return $0.voteNum.value > $1.voteNum.value
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

    func voteWithPow(nodeName: String, tryToCancel: @escaping () -> Bool, completion: @escaping (NetworkResult<Void>) -> Void) {
        guard let bag = HDWalletManager.instance.bag else { return }

        Provider.instance.voteWithPow(bag: bag,
                                      benefitedNodeName: nodeName,
                                      tryToCancel: tryToCancel) { (result) in
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
