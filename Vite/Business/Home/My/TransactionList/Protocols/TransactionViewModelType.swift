//
//  TransactionViewModelType.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import UIKit

protocol TransactionViewModelType {
    var typeImage: UIImage { get }
    var timeString: String { get }
    var hash: String { get }
    var balanceString: String { get }
}
