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

    #if DEBUG
    var rpcURL: URL {
        if DebugService.instance.rpcUseHTTP {
            return URL(string: "http://150.109.120.109:48132")!
        } else {
            return URL(string: "https://testnet.vitewallet.com/ios")!
        }
    }
    #else
    let rpcURL = URL(string: "https://testnet.vitewallet.com/ios")!
    #endif
}
