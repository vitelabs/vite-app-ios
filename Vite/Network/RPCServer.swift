//
//  RPCServer.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

//enum RPCServer {
//    case main
//    case custom(url: URL)
//
//    var rpcURL: URL {
//        switch self {
//        case .main:
//            return URL(string: "http://127.0.0.1:48132")!
//        case .custom(let url):
//            return url
//        }
//    } 
//}

final class RPCServer {
    static let shared = RPCServer()
    private init() {}

    var rpcURL = URL(string: "http://127.0.0.1:48132")!
}
