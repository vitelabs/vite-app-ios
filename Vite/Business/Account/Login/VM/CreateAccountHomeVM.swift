//
//  LoginVM.swift
//  Vite
//
//  Created by Water on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CreateAccountHomeVM: NSObject {
    var createAccountBtnStr  =  BehaviorRelay(value: R.string.localizable.createAccount())
    var recoverAccountBtnStr = BehaviorRelay(value: R.string.localizable.importAccount())
    var changeLanguageBtnStr = BehaviorRelay(value: LocalizationService.sharedInstance.currentLanguage.name)
    override init() {
        super.init()
        self.initBinds()
    }

    func initBinds() {
        NotificationCenter.default.rx
            .notification(.languageChanged)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }

                self.createAccountBtnStr.accept(R.string.localizable.createAccount())
                self.recoverAccountBtnStr.accept(R.string.localizable.importAccount())
            self.changeLanguageBtnStr.accept(LocalizationService.sharedInstance.currentLanguage.name)
            }).disposed(by: rx.disposeBag)
    }
}
