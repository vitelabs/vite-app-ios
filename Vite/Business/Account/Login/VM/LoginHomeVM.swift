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

final class LoginHomeVM: NSObject {
    var createAccountBtnStr  =  Variable("create account".localized())
    var recoverAccountBtnStr = Variable(LocalizationStr("import account"))
    var changeLanguageBtnStr = Variable(SettingDataService.sharedInstance.getCurrentLanguage().displayName)

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

                self.createAccountBtnStr.value = LocalizationStr("create account")
                self.recoverAccountBtnStr.value = LocalizationStr("import account")
                self.changeLanguageBtnStr.value = SettingDataService.sharedInstance.getCurrentLanguage().displayName
            }).disposed(by: rx.disposeBag)
    }
}
