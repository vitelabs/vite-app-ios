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
                    seal.fulfill(BalanceInfo.mergeBalanceInfos(balanceInfos, unConfirmedInfos: unConfirmedInfos))
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

    fileprivate func getTokenForId(_ id: String) -> Promise<Token?> {
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

    func getTokenForId(_ id: String, completion: @escaping (NetworkResult<Token?>) -> Void) {
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

    func recoverAddresses(_ addresses: [Address], completion: @escaping (NetworkResult<Int>) -> Void) {
        guard addresses.count == 10 else { fatalError() }

        func makePromise(startIndex: Int) -> Promise<Int?> {
            let start = startIndex
            let mid = start + 1
            let end = mid + 1
            return Promise<Int?> { seal in
                let request = ViteServiceRequest(for: server, batch: BatchFactory()
                    .create(request1: GetBalanceInfosRequest(address: addresses[start].description),
                            GetUnconfirmedInfosRequest(address: addresses[start].description),
                            GetBalanceInfosRequest(address: addresses[mid].description),
                            GetUnconfirmedInfosRequest(address: addresses[mid].description),
                            GetBalanceInfosRequest(address: addresses[end].description),
                            GetUnconfirmedInfosRequest(address: addresses[end].description)))
                Session.send(request) { result in
                    switch result {
                    case .success(let (bStart, uStart, bMid, uMid, bEnd, uEnd)):
                        let s = BalanceInfo.mergeBalanceInfos(bStart, unConfirmedInfos: uStart)
                        let m = BalanceInfo.mergeBalanceInfos(bMid, unConfirmedInfos: uMid)
                        let e = BalanceInfo.mergeBalanceInfos(bEnd, unConfirmedInfos: uEnd)
                        if !e.isEmpty {
                            seal.fulfill(end)
                        } else if !m.isEmpty {
                            seal.fulfill(mid)
                        } else if !s.isEmpty {
                            seal.fulfill(start)
                        } else {
                            seal.fulfill(nil)
                        }
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            }
        }

        let p123 = makePromise(startIndex: 1)
        let p456 = makePromise(startIndex: 4)
        let p789 = makePromise(startIndex: 7)

        when(fulfilled: p123, p456, p789)
            .done ({ (p1, p4, p7) in
                let count = (p7 ?? p4 ?? p1 ?? 0) + 1
                completion(NetworkResult.success(count))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }
}
