//
//  SnapshotChainProvider.swift
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

final class SnapshotChainProvider {
    let server: RPCServer

    init(server: RPCServer) {
        self.server = server
    }

    func height() -> Promise<String> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(SnapshotChainHeightRequest()))
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
