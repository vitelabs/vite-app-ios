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
    case getAppConfig
    case checkUpdate
}

extension COSAPI: TargetType {

    var baseURL: URL {
        #if DEBUG
        return DebugService.instance.configEnvironment.url
        #else
        return URL(string: "https://testnet-vite-1257137467.cos.ap-hongkong.myqcloud.com/config")!
        #endif
    }

    var path: String {
        switch self {
        case .getAppConfig:
            return "/AppConfig"
        case .checkUpdate:
            return Constants.appDownloadChannel == .appstore ? "AppStoreCheckUpdate" : "/EnterpriseCheckUpdate"
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
