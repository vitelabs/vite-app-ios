//
//  RPCServer.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

final class RPCServer {
    static let shared = RPCServer()
    private init() {}

    var rpcURL = URL(string: "https://test.vitewallet.com/ios")!
}
