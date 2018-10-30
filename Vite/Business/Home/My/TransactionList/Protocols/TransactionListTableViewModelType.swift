//
//  TransactionListTableViewModelType.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TransactionListTableViewModelType {
    var transactionsDriver: Driver<[TransactionViewModelType]> { get }
}
