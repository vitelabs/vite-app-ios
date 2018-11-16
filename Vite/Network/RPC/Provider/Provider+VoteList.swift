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

private let gID = "00000000000000000001"
private let voteContractAddress = Address(string: "vite_000000000000000000000000000000000000000270a48cc491")

// MARK: Vote
extension Provider {

    func getCandidateList(gid: String = gID, completion: @escaping ((NetworkResult<[Candidate]>) -> Void)) -> SessionTask? {
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

    func getVoteData(benefitedNodeName name: String, gid: String = gID) -> Promise<String> {
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
              gid: String = gID,
              completion: @escaping (NetworkResult<Void>) -> Void) {
         getVoteData(benefitedNodeName: name, gid: gid)
            .done({ data in
                self.sendTransactionWithoutGetPow(bag: bag,
                                                  toAddress: voteContractAddress,
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
                     gid: String = gID,
                     tryToCancel: @escaping () -> Bool,
                     completion: @escaping (NetworkResult<Void>) -> Void) {
        getVoteData(benefitedNodeName: name, gid: gid)
            .done({ [unowned self] (data)  in
                if tryToCancel() { return }
                self.sendTransactionWithGetPow(bag: bag,
                                               toAddress: voteContractAddress,
                                               tokenId: TokenCacheService.instance.viteToken.id,
                                               amount: 0,
                                               data: data,
                                               difficulty: AccountBlock.Const.Difficulty.vote.value,
                                               completion: { result in
                                                if tryToCancel() { return }
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
