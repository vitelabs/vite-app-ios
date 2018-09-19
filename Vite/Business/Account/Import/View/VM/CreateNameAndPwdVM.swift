//
//  CreateNameAndPwdVM.swift
//  Vite
//
//  Created by Water on 2018/9/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Action
import RxCocoa
import RxSwift

final class CreateNameAndPwdVM {
    let submitBtnEnable: Driver<Bool>
    let submitAction: Action<(String, String, String), CreateWalletResult> = Action {(name, pwd, rePwd) in
        //TODO... 本地化
        if name.isEmpty || pwd.isEmpty || rePwd.isEmpty {
            return Observable.just(.empty(message:"用户名或者密码必须输入"))
        }
        if  !ViteInputValidator.isValidWalletName(str: name  ) {
            return Observable.just(.failed(message: "用户名中文英文"))
        }
        if  !ViteInputValidator.isValidWalletNameCount(str: name) {
            return Observable.just(.failed(message: "超出字符限制"))
        }
        if  pwd != rePwd {
            return Observable.just(.empty(message:"密码和重复输入的密码不相同"))
        }
        return Observable.just(.ok(message:""))
    }

    var accountNameTF: UITextField
    private var passwordTF: UITextField
    private var repeatePwdTF: UITextField

    init(input:(accountNameTF: UITextField, passwordTF: UITextField, repeatePwdTF: UITextField)) {
        accountNameTF = input.accountNameTF
        passwordTF = input.passwordTF
        repeatePwdTF = input.repeatePwdTF

        let accountDriver = input.accountNameTF.rx.text.orEmpty.asDriver()
        let passwordDriver = input.passwordTF.rx.text.orEmpty.asDriver()
        let repeatePwdTFDriver = input.repeatePwdTF.rx.text.orEmpty.asDriver()

        let createAccountIsOK = Driver.combineLatest(accountDriver, passwordDriver, repeatePwdTFDriver) {
            return ($0, $1, $2)
        }

        submitBtnEnable = createAccountIsOK.flatMap { (arg) -> SharedSequence<DriverSharingStrategy, Bool> in
            let (account, password, rePwd) = arg
            return CreateWalletAccountVM.handleLoginBtnEnable(account, pwd: password, rePwd: rePwd).asDriver(onErrorJustReturn: false)
        }
    }

    static func handleLoginBtnEnable(_ name: String, pwd: String, rePwd: String) -> Observable<Bool> {
        if name.isEmpty || pwd.isEmpty || rePwd.isEmpty {
            return Observable.just(false)
        }

        if !ViteInputValidator.isValidWalletPasswordCount(str: pwd) ||
            !ViteInputValidator.isValidWalletPasswordCount(str: rePwd) {
            return Observable.just(false)
        }
        return Observable.just(true)
    }
}
