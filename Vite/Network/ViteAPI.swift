//
//  ViteAPI.swift
//  Vite
//
//  Created by Water on 2018/9/27.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import Moya

enum ViteAPI {
    case getAppUpdate([String: String])
    case getAppSystemManageConfig([String: String])
    case getAppDefaultTokens([String: String])
}

extension ViteAPI: TargetType {

    var baseURL: URL { return URL.init(string: Constants.viteCentralizedHost)! }

    var path: String {
        switch self {
        case .getAppUpdate:
            return "/api/version/update"
        case .getAppSystemManageConfig:
            return "/api/version/config"
        case .getAppDefaultTokens:
            return "/api/version/config"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAppUpdate: return .get
        case .getAppSystemManageConfig: return .get
        case .getAppDefaultTokens: return .get
        }
    }

    var task: Task {
        switch self {
        case .getAppUpdate(let value):
           return .requestParameters(parameters: value, encoding: URLEncoding())
        case .getAppSystemManageConfig((let value)):
            return .requestParameters(parameters: value, encoding: URLEncoding())
        case .getAppDefaultTokens((let value)):
            return .requestParameters(parameters: value, encoding: URLEncoding())
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "client": Bundle.main.bundleIdentifier ?? "",
            "client-build": Bundle.main.buildNumber ?? "",
        ]
    }
}
