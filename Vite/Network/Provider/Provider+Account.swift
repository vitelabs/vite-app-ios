//
//  Provider+Account.swift
//  Vite
//
//  Created by Stone on 2018/9/20.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit
import JSONRPCKit
import APIKit

extension Provider {

    fileprivate func getBalanceInfos(address: Address) -> Promise<[BalanceInfo]> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetBalanceInfosRequest(address: address.description), GetUnconfirmedInfosRequest(address: address.description)))
            Session.send(request) { result in
                switch result {
                case .success(let (balanceInfos, unConfirmedInfos)):
                    var ret = [BalanceInfo]()
                    for balanceInfo in balanceInfos {
                        var info = balanceInfo
                        for unConfirmedInfo in unConfirmedInfos where balanceInfo.token.id == unConfirmedInfo.token.id {
                            info.fill(unconfirmedBalance: unConfirmedInfo.unconfirmedBalance, unconfirmedCount: unConfirmedInfo.unconfirmedCount)
                            break
                        }
                        ret.append(info)
                    }
                    seal.fulfill(ret)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getTransactions(address: Address, hash: String?, count: Int) -> Promise<(transactions: [Transaction], hasMore: Bool)> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetTransactionsRequest(address: address.description, hash: hash, count: count)))
            Session.send(request) { result in
                switch result {
                case .success(let (transactions, hasMore)):
                    seal.fulfill((transactions, hasMore))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getTokenForId(_ id: String) -> Promise<Token> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetTokenInfoRequest(tokenId: id)))
            Session.send(request) { result in
                switch result {
                case .success(let token):
                    seal.fulfill(token)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getSnapshotChainHeight() -> Promise<String> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetSnapshotChainHeightRequest()))
            Session.send(request) { result in
                switch result {
                case .success(let height):
                    seal.fulfill(height)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

extension Provider {

    func getBalanceInfos(address: Address, completion: @escaping (NetworkResult<[BalanceInfo]>) -> Void) {
        getBalanceInfos(address: address)
            .done({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func getTransactions(address: Address,
                         hash: String?,
                         count: Int,
                         completion: @escaping (NetworkResult<(transactions: [Transaction], hasMore: Bool)>) -> Void) {
        getTransactions(address: address, hash: hash, count: count)
            .done({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func getTokenForId(_ id: String, completion: @escaping (NetworkResult<Token>) -> Void) {
        getTokenForId(id)
            .done({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func getSnapshotChainHeight(completion: @escaping (NetworkResult<String>) -> Void) {
        getSnapshotChainHeight()
            .done({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }
}
