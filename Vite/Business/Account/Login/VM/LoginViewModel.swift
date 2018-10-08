//
//  LoginViewModel.swift
//  Vite
//
//  Created by Water on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Vite_HDWalletKit

final class LoginViewModel: NSObject {

    public var chooseWalletAccount: WalletAccount = WalletDataService.shareInstance.defaultWalletAccount!
    public var walletStorage = WalletStorage()

    override init() {
        super.init()
    }
}
