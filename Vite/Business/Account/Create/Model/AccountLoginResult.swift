//
//  AccountLoginResult.swift
//  Vite
//
//  Created by Water on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

enum CreateWalletResult {
    case ok(message:String)
    case empty(message:String)
    case failed(message:String)
}

extension CreateWalletResult {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case let .empty(message):
             return message
        case let .failed(message):
            return message
        }
    }
}
