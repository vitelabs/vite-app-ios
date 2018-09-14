//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import PromiseKit
import BigInt
import APIKit
import JSONRPCKit

final class TransactionProvider {
    let server: RPCServer

    init(server: RPCServer) {
        self.server = server
    }

    func getUnconfirmedTransaction(address: Address) -> Promise<[AccountBlock]> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetUnconfirmedTransactionRequest(address: address.description)))
            Session.send(request) { result in
                switch result {
                case .success(let accountBlocks):
                    seal.fulfill(accountBlocks)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
