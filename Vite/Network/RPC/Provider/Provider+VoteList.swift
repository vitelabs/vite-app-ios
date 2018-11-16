//
//  Provider+VoteList.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit
import JSONRPCKit
import APIKit
import BigInt

// MARK: Vote
extension Provider {

    func getCandidateList(gid: String = Const.gid, completion: @escaping ((NetworkResult<[Candidate]>) -> Void)) -> SessionTask? {
            let batch = BatchFactory().create(GetCandidateListRequest(gid: gid))
            let request = ViteServiceRequest(for: server, batch: batch)
            return Session.send(request) { result in
                switch result {
                case .success(let result):
                    completion(NetworkResult.success(result))
                case .failure(let error):
                    completion(NetworkResult.wrapError(error))
                }
            }
    }

    func getVoteData(benefitedNodeName name: String, gid: String = Const.gid) -> Promise<String> {
        return Promise<String> { seal in
            let batch = BatchFactory().create(GetVoteDataRequest(gid: gid, name: name))
            let request = ViteServiceRequest(for: server, batch: batch)
            Session.send(request) { result in
                switch result {
                case .success(let accountBlocksh):
                    seal.fulfill(accountBlocksh)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func vote(bag: HDWalletManager.Bag,
              benefitedNodeName name: String,
              gid: String = Const.gid,
              completion: @escaping (NetworkResult<Void>) -> Void) {
         getVoteData(benefitedNodeName: name, gid: gid)
            .done({ data in
                self.sendTransactionWithoutGetPow(bag: bag,
                                                  toAddress: Const.ContractAddress.vote.address,
                                                  tokenId: TokenCacheService.instance.viteToken.id,
                                                  amount: 0,
                                                  data: data,
                                                  completion: { result in
                                                    switch result {
                                                    case .success:
                                                        completion(NetworkResult.success(Void()))
                                                    case .error(let error):
                                                        completion(NetworkResult.error(error))
                                                    }

                })
            })
            .catch {
                completion(NetworkResult.error($0))
            }

    }

    func voteWithPow(bag: HDWalletManager.Bag,
                     benefitedNodeName name: String,
                     gid: String = Const.gid,
                     tryToCancel: @escaping () -> Bool,
                     powCompletion: @escaping (NetworkResult<SendTransactionContext>) -> Void,
                     completion: @escaping (NetworkResult<Void>) -> Void) {
        getVoteData(benefitedNodeName: name, gid: gid)
            .done({ [unowned self] (data)  in
                if tryToCancel() { return }
                self.sendTransactionWithGetPow(bag: bag,
                                               toAddress: Const.ContractAddress.vote.address,
                                               tokenId: TokenCacheService.instance.viteToken.id,
                                               amount: 0,
                                               data: data,
                                               difficulty: AccountBlock.Const.Difficulty.vote.value,
                                               completion: { result in
                                                if tryToCancel() { return }
                                                powCompletion(result)
                                                switch result {
                                                case .success(let context) :
                                                    self.sendTransactionWithContext(context, completion: { (result) in
                                                        switch result {
                                                        case .success:
                                                            completion(NetworkResult.success(Void()))
                                                        case .error(let error):
                                                            completion(NetworkResult.error(error))
                                                        }
                                                    })
                                                case .error(let error):
                                                    completion(NetworkResult.error(error))
                                                }
                })
            })
            .catch {
                completion(NetworkResult.error($0))
            }
    }

}
