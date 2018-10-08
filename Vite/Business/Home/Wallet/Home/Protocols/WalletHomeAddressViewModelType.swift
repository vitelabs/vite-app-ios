//
//  WalletHomeAddressViewModelType.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WalletHomeAddressViewModelType {
    var defaultAddressDriver: Driver<String> { get }
    func copy()
}
