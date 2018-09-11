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

final class CreateWalletAccountVM {
    static let maxCharactersCount = 32

    let accountNameEnable: Driver<CreateWalletResult>
    let inputPwdEnable: Driver<CreateWalletResult>
    let inputRepeatePwdEnable: Driver<CreateWalletResult>
    let submitBtnEnable: Driver<Bool>

    init(input:(accountNameTF: UITextField, passwordTF: UITextField, repeatePwdTF: UITextField)) {
        let accountDriver = input.accountNameTF.rx.text.orEmpty.asDriver()
        let passwordDriver = input.passwordTF.rx.text.orEmpty.asDriver()
        let repeatePwdTFDriver = input.repeatePwdTF.rx.text.orEmpty.asDriver()

       accountNameEnable = accountDriver.skip(1).flatMapLatest {accountName  in
            return CreateWalletAccountVM.handleAccountNameValid(accountName).asDriver(onErrorJustReturn: .failed(message: "用户名至少是6个字符"))
       }

        inputPwdEnable = passwordDriver.skip(1).flatMapLatest {pwd  in
            return CreateWalletAccountVM.handleAccountNameValid(pwd).asDriver(onErrorJustReturn: .failed(message: ""))
        }

        inputRepeatePwdEnable = repeatePwdTFDriver.skip(1).flatMapLatest {pwd  in
            return CreateWalletAccountVM.handleRepeatePasswordValid(pwd).asDriver(onErrorJustReturn: .failed(message: ""))
        }

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

        if pwd != rePwd {
            return Observable.just(false)
        }

        return Observable.just(true)
    }

    static func handleAccountNameValid(_ name: String) -> Observable<CreateWalletResult> {
        if name.isEmpty {
            return Observable.just(.empty(message:"用户名必须输入"))
        }
        if name.count > maxCharactersCount {
            return Observable.just(.failed(message: "超出字符限制"))
        }
        // TODO:::
        // 格式合法性判断
        return Observable.just(.ok(message:""))
    }

    static func handlePasswordValid(_ name: String) -> Observable<CreateWalletResult> {
        if name.isEmpty {
            return Observable.just(.empty(message:"密码必须输入"))
        }
        if name.count < maxCharactersCount {
            return Observable.just(.failed(message: "用户名至少是6个字符"))
        }
        return Observable.just(.ok(message:""))
    }

    static func handleRepeatePasswordValid(_ name: String) -> Observable<CreateWalletResult> {
        if name.isEmpty {
            return Observable.just(.empty(message:"密码必须输入"))
        }
        if name.count < maxCharactersCount {
            return Observable.just(.failed(message: "用户名至少是6个字符"))
        }
        return Observable.just(.ok(message:""))
    }
}
