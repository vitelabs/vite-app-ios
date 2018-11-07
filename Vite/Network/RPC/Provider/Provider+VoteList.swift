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
private let voteContractAddress = Address(string: "vite_0000000000000000000000000000000000000001c9e9f25417")

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
            .then({ [unowned self] (data) -> Promise<(latestAccountBlock: AccountBlock, fittestSnapshotHash: String, data: String)> in
                return self.getLatestAccountBlockAndSnapshotHash(address: bag.address)
                    .then({ (latestAccountBlock, fittestSnapshotHash) in
                        return Promise { seal in
                            seal.fulfill((latestAccountBlock, fittestSnapshotHash, data))
                        }
                })
            })
            .then({ [unowned self] (latestAccountBlock, fittestSnapshotHash, data) -> Promise<Void> in
                let send = AccountBlock.makeSendAccountBlock(latest: latestAccountBlock,
                                                             bag: bag,
                                                             snapshotHash: fittestSnapshotHash,
                                                             toAddress: voteContractAddress,
                                                             tokenId: TokenCacheService.instance.viteToken.id,
                                                             amount: 0,
                                                             data: data,
                                                             nonce: nil,
                                                             difficulty: nil)
                return self.createTransaction(accountBlock: send)
            })
            .done({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

}
