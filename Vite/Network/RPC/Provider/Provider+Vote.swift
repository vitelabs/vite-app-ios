//
//  Provider+Vote.swift
//  Vite
//
//  Created by Water on 2018/11/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit
import JSONRPCKit
import APIKit
import BigInt

// MARK: Vote
extension Provider {
    fileprivate func getVoteInfo(address: String) -> Promise<(VoteInfo?)> {
        return Promise { seal in
            var request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(GetVoteInfoRequest(gid: Const.gid, address: address)))
            request.timeoutInterval = 10.0
            Session.send(request) { result in
                switch result {
                case .success(let voteInfo):
                    seal.fulfill(voteInfo)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

     func cancelVote() -> Promise<(String)> {
        return Promise { seal in
            var request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(CancelVoteRequest(gid: Const.gid)))
            request.timeoutInterval = 10.0
            Session.send(request) { result in
                switch result {
                case .success(let voteInfo):
                    seal.fulfill(voteInfo)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

extension Provider {
    func getVoteInfo(address: String, completion: @escaping (NetworkResult<(VoteInfo?)>) -> Void) {
        getVoteInfo(address: address)
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func cancelVoteAndSendWithoutGetPow(bag: HDWalletManager.Bag,
                                        completion: @escaping (NetworkResult<Void>) -> Void) {
        self.cancelVote()
            .then({ [unowned self] (data) -> Promise<(latestAccountBlock: AccountBlock, fittestSnapshotHash: String, data: String)> in
                return self.getLatestAccountBlockAndSnapshotHash(address: bag.address).then({ (latestAccountBlock, fittestSnapshotHash) in
                    return Promise { seal in seal.fulfill((latestAccountBlock, fittestSnapshotHash, data)) }
                })
            })
            .then({ [unowned self] (latestAccountBlock, fittestSnapshotHash, data) -> Promise<Void> in
                let send = AccountBlock.makeSendAccountBlock(latest: latestAccountBlock,
                                                             bag: bag,
                                                             snapshotHash: fittestSnapshotHash,
                                                             toAddress: Const.ContractAddress.vote.address,
                                                             tokenId: TokenCacheService.instance.viteToken.id,
                                                             amount: BigInt(0),
                                                             data: data,
                                                             nonce: nil,
                                                             difficulty: nil)
                return self.createTransaction(accountBlock: send)
            })
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func cancelVoteAndSendWithGetPow(bag: HDWalletManager.Bag, completion:@escaping (NetworkResult<Void>) -> Void) {
        cancelVote()
            .done({ [unowned self] (data)  in
                self.sendTransactionWithGetPow(bag: bag,
                                               toAddress: Const.ContractAddress.vote.address,
                                               tokenId: TokenCacheService.instance.viteToken.id,
                                               amount: 0,
                                               data: data,
                                               difficulty: AccountBlock.Const.Difficulty.cancelVote.value,
                                               completion: { result in
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
