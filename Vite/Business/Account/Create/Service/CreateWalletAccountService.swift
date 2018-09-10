//
//  CreateWalletAccountService.swift
//  Vite
//
//  Created by Water on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreateWalletAccountService {

    static let shareInstance = CreateWalletAccountService()
    private init() {}

    // 验证账号是否合法
    func validationAccount(_ account: String) -> Observable<CreateWalletResult> {

        if account.count > 32 {
            return Observable.just(CreateWalletResult.failed(message: "账号非法"))
        }

        return Observable.just(CreateWalletResult.ok(message: "账号合法"))
    }


}
