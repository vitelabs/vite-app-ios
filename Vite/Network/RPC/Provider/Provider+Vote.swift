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
            let request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(GetVoteInfoRequest(address: address.description)))
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
            let request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(CancelVoteRequest()))
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
}
