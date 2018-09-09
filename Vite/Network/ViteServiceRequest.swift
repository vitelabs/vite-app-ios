//
//  ViteServiceRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit

struct ViteServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch
    let server: RPCServer
    typealias Response = Batch.Responses

    var timeoutInterval: Double

    init(
        for server: RPCServer,
        batch: Batch,
        timeoutInterval: Double = 30.0
        ) {
        self.server = server
        self.batch = batch
        self.timeoutInterval = timeoutInterval
    }

    var baseURL: URL {
        return server.rpcURL
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/"
    }

    var parameters: Any? {
        return batch.requestObject
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.timeoutInterval = timeoutInterval
        return urlRequest
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}
