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
import NSObject_Rx
import Vite_HDWalletKit

final class SystemViewModel: NSObject {
    var isRequireAuthentication =  false
    var isAuthenticatedByBiometry =  false
    var isTransferByBiometry = false
    var isTransferByBiometryHide = true

    override init() {
        super.init()
        HDWalletManager.instance.walletDriver.drive(onNext: { [weak self] (wallet) in
            guard let `self` = self else { return }
            self.isRequireAuthentication = wallet.isRequireAuthentication
            self.isAuthenticatedByBiometry = wallet.isAuthenticatedByBiometry
            self.isTransferByBiometry = wallet.isTransferByBiometry

        }).disposed(by: rx.disposeBag)

        if BiometryAuthenticationType.current == .none {
            isTransferByBiometryHide = true
        } else {
            isTransferByBiometryHide = false
        }
    }

}
