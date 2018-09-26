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

    var rpcURL = URL(string: "http://192.168.31.50:48132")!
//    var rpcURL = URL(string: "http://192.168.31.237:48132")!
}
