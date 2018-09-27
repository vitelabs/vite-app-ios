//
//  AppUpdateVM.swift
//  Vite
//
//  Created by Water on 2018/9/27.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import ObjectMapper
import Alamofire
import Foundation
import Moya


class AppUpdateVM: NSObject {

    public func fetch() {
        let policies: [String: ServerTrustPolicy] = [:]
        let manager = Manager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
        )
        let provider =  MoyaProvider<ViteAPI>(manager: manager)

        let viteAppServiceRequest = ViteAppServiceRequest.init(provider: provider)

        let _ = viteAppServiceRequest.getAppSystemManageConfig().done { [weak self] tokens in
            guard let token = tokens.first else { return }

        }

    }
}


