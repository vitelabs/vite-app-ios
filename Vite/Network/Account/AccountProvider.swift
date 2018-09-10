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

    func getTransactions(address: Address, index: Int = 0) -> Promise<[Transaction]> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetTransactionsRequest(address: address.description, index: index)))
            Session.send(request) { result in
                switch result {
                case .success(let transactions):
                    seal.fulfill(transactions)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func getBalanceInfos(address: Address) -> Promise<[BalanceInfo]> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetBalanceInfosRequest(address: address.description)))
            Session.send(request) { result in
                switch result {
                case .success(let balanceInfo):
                    seal.fulfill(balanceInfo)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
