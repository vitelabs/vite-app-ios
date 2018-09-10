//
//  AccountLoginResult.swift
//  Vite
//
//  Created by Water on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation

enum CreateWalletResult {
    case ok(message:String)
    case empty
    case failed(message:String)
}
