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
    case getAppUpdate
    case getAppDefaultTokens
    case getAppSettingsConfig
}

extension ViteAPI: TargetType {

    var baseURL: URL { return URL.init(string: Constants.viteCentralizedHost)! }

    var path: String {
        switch self {
        case .getAppUpdate:
            return "/api/version/update"
        case .getAppDefaultTokens:
            return "/api/version/config"
        case .getAppSettingsConfig:
            return "/api/version/config"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAppUpdate: return .get
        case .getAppDefaultTokens: return .get
        case .getAppSettingsConfig: return .get
        }
    }

    var task: Task {
        switch self {
        case .getAppUpdate:
            #if DEBUG
            let value = [
                "version": "test",
                "app": "iphone",
                "channel": Constants.appDownloadChannel, ]
            #else
            let value = [
                "version": Bundle.main.buildNumber ?? "1",
                "app": "iphone",
                "channel": Constants.appDownloadChannel, ]
            #endif
           return .requestParameters(parameters: value, encoding: URLEncoding())
        case .getAppDefaultTokens:
            let value = [
                "version": "default",
                "app": "iphone",
                "channel": "token",
                ]
            return .requestParameters(parameters: value, encoding: URLEncoding())
        case .getAppSettingsConfig:
            let value = [
                "version": Bundle.main.versionNumber ?? "1.0",
                "app": "iphone",
                "channel": Constants.appDownloadChannel,
                ]
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
