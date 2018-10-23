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

        if name.isEmpty || pwd.isEmpty || rePwd.isEmpty {
            return Observable.just(.empty(message:         R.string.localizable.mnemonicBackupPageErrorTypeName.key.localized()))
        }
        if  !ViteInputValidator.isValidWalletName(str: name  ) {
            return Observable.just(.failed(message:         R.string.localizable.mnemonicBackupPageErrorTypeNameValid.key.localized()))
        }
        if  !ViteInputValidator.isValidWalletNameCount(str: name) {
            return Observable.just(.failed(message: R.string.localizable.mnemonicBackupPageErrorTypeValidWalletNameCount.key.localized()))
        }
        if  pwd != rePwd {
            return Observable.just(.empty(message:R.string.localizable.mnemonicBackupPageErrorTypeDifference.key.localized()))
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
            return CreateNameAndPwdVM.handleLoginBtnEnable(account, pwd: password, rePwd: rePwd).asDriver(onErrorJustReturn: false)
        }
    }

    static func handleLoginBtnEnable(_ name: String, pwd: String, rePwd: String) -> Observable<Bool> {
        if name.isEmpty || pwd.isEmpty || rePwd.isEmpty {
            return Observable.just(false)
        }

        if !ViteInputValidator.isValidWalletPassword(str: pwd) ||
            !ViteInputValidator.isValidWalletPassword(str: rePwd) {
            return Observable.just(false)
        }

        return Observable.just(true)
    }
}
