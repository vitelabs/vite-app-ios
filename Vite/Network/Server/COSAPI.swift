//
//  COSAPI.swift
//  Vite
//
//  Created by Stone on 2018/11/5.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation
import Moya

enum COSAPI {
    case getConfigHash
    case getAppConfig
    case getLocalizable(String)
    case checkUpdate
}

extension COSAPI: TargetType {

    var baseURL: URL {
        #if DEBUG || TEST
        return DebugService.instance.configEnvironment.url
        #else
        return URL(string: "https://testnet-vite-1257137467.cos.ap-hongkong.myqcloud.com/config")!
        #endif
    }

    var path: String {
        switch self {
        case .getConfigHash:
            return "/ConfigHash"
        case .getAppConfig:
            return "/AppConfig"
        case .getLocalizable(let language):
            return "/Localization/\(language)"
        case .checkUpdate:
            switch Constants.appDownloadChannel {
            case .appstore:
                return "/AppStoreCheckUpdate"
            case .enterprise:
                return "/EnterpriseCheckUpdate"
            }
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestParameters(parameters: [:], encoding: URLEncoding())
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return nil
    }
}
