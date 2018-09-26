//
//  SystemViewModel.swift
//  Vite
//
//  Created by Water on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Action
import RxCocoa
import RxSwift
import Vite_keystore

final class SystemViewModel: NSObject {
    var isSwitchPwdBehaviorRelay =  BehaviorRelay<Bool>(value: WalletDataService.shareInstance.defaultWalletAccount?.isSwitchPwd ?? false)
    var isSwitchTouchIdBehaviorRelay =  BehaviorRelay<Bool>(value: WalletDataService.shareInstance.defaultWalletAccount?.isSwitchTouchId ?? false)
    var isSwitchTransferBehaviorRelay =  BehaviorRelay<Bool>(value: WalletDataService.shareInstance.defaultWalletAccount?.isSwitchTransfer ?? true)
    var isSwitchTransferHideBehaviorRelay =  BehaviorRelay<Bool>(value: WalletDataService.shareInstance.defaultWalletAccount?.isSwitchTransfer ?? true)

    override init() {
        super.init()

        if BiometryAuthenticationType.current == .none {
            isSwitchTransferHideBehaviorRelay.accept(true)
        } else {
            isSwitchTransferHideBehaviorRelay.accept(false)
        }
    }

}
