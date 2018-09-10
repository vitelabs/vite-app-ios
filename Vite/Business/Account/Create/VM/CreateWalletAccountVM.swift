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
    

    static let maxCharactersCount = 32

    var inputPwdStr : String?
    var repeatInputPwdStr : String?

    let accountNameEnable : Driver<CreateWalletResult>
    let inputPwdEnable : Driver<CreateWalletResult>

    init(input:(accountName:Driver<String>,passwd:Driver<String>)) {
           accountNameEnable = input.accountName.flatMapLatest{ accountName  in
            return CreateWalletAccountVM.handleAccountNameValid(accountName).asDriver(onErrorJustReturn: .failed(message: ""))
        }

        inputPwdEnable = input.accountName.flatMapLatest{ accountName  in
            return CreateWalletAccountVM.handleAccountNameValid(accountName).asDriver(onErrorJustReturn: .failed(message: ""))
        }


    }

    static func handleAccountNameValid(_ name:String) -> Observable<CreateWalletResult> {
        if name.isEmpty {
            return Observable.just(.empty)
        }
        if name.count < maxCharactersCount  {
            return Observable.just(.failed(message: "用户名至少是6个字符"))
        }
        return Observable.just(.ok(message:"用户名可用"))
    }

    static func handlePasswordValid(_ name:String) -> Observable<CreateWalletResult> {
        if name.isEmpty {
            return Observable.just(.empty)
        }
        if name.count < maxCharactersCount  {
            return Observable.just(.failed(message: "用户名至少是6个字符"))
        }
        return Observable.just(.ok(message:"用户名可用"))
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
