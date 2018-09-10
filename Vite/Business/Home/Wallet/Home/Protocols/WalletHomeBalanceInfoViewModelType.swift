//
//  WalletHomeBalanceInfoViewModelType.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import UIKit

protocol WalletHomeBalanceInfoViewModelType {
    var iconImage: UIImage { get }
    var name: String { get }
    var balance: String { get }
    var unconfirmed: String { get }
}
