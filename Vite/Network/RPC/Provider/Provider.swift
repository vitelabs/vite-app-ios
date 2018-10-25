//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import APIKit
import JSONRPCKit

final class Provider {
    static let instance = Provider(server: RPCServer.shared)

    let server: RPCServer
    init(server: RPCServer) {
        self.server = server
    }
}
