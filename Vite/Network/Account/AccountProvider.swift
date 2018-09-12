//
//  AccountProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit
import BigInt
import APIKit
import JSONRPCKit

final class AccountProvider {
    let server: RPCServer

    init(server: RPCServer) {
        self.server = server
    }

    func getTransactions(address: Address, index: Int = 0, count: Int) -> Promise<(transactions: [Transaction], hasMore: Bool)> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetTransactionsRequest(address: address.description, index: index, count: count)))
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

    func getBalanceInfos(address: Address) -> Promise<[BalanceInfo]> {
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
}
