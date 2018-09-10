//
//  CreateWalletAccountVM.swift
//  Vite
//
//  Created by Water on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CreateWalletAccountVM: NSObject {
    var accountNameStr  =  Variable("")
    

    let maxCharactersCount = 32

    var inputPwdStr : String?
    var repeatInputPwdStr : String?

//    let accountNameEnable:Driver<CreateWalletResult>
//    let userPasswordAble:Driver<CreateWalletResult>
//    let loginButtonEnabled :Driver<CreateWalletResult>
//    let loginResult:Driver<CreateWalletResult>

//    let accountUseable: Driver<CreateWalletResult>
//    let passwordUseable: Driver<CreateWalletResult>
//    let loginBtnEnable: Driver<Bool>
//    let loginResult: Driver<CreateWalletResult>
//
//    init(input: (accountField: UITextField, passwordField: UITextField, loginBtn: UIButton), service: CreateWalletAccountService)  {
//
//        let accountDriver = input.accountField.rx.text.orEmpty.asDriver()
//        let passwordDriver = input.passwordField.rx.text.orEmpty.asDriver()
//        let loginTapDriver = input.loginBtn.rx.tap.asDriver()
//
//        accountUseable = accountDriver.skip(1).flatMapLatest { account in
//            return service.validationAccount(account).asDriver(onErrorJustReturn: .failed(message: "连接service失败"))
//        }
//        }
//    }




//    init(input:(accountName:Driver<String>,passwd:Driver<String>)) {
//           accountNameEnable = input.accountName.flatMapLatest{ accountName  in
//            return self.handleAccountNameValid(accountName)
//
//        }
//
//
//    }

    func handleAccountNameValid(_ name:String) -> Observable<CreateWalletResult> {
        if name.isEmpty {
            return .just(.empty)
        }
        if name.count < maxCharactersCount  {
            return .just(.failed(message: "用户名至少是6个字符"))
        }
        return .just(.ok(message:"用户名可用"))
    }


    func initBinds() {
//        NotificationCenter.default.rx
//            .notification(.languageChanged)
//            .takeUntil(self.rx.deallocated)
//            .subscribe(onNext: { [weak self] (_) in
//                guard let `self` = self else { return }
//
//
//            }).disposed(by: rx.disposeBag)
    }
}
