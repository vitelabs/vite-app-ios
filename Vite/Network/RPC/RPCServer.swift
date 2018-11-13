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

    #if DEBUG || TEST
    var rpcURL: URL {
        if DebugService.instance.rpcUseOnlineUrl {
            return URL(string: "https://testnet.vitewallet.com/ios")!
        } else {
            if let url = URL(string: DebugService.instance.rpcCustomUrl) {
                return url
            } else {
                return DebugService.instance.rpcDefaultTestEnvironmentUrl
            }
        }
    }
    #else
    let rpcURL = URL(string: "https://testnet.vitewallet.com/ios")!
    #endif
}
