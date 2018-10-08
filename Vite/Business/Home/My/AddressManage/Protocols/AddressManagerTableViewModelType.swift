//
//  AddressManagerTableViewModelType.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddressManagerTableViewModelType {
    var defaultAddressDriver: Driver <String> { get }
    var addressesDriver: Driver<[AddressManageAddressViewModelType]> { get }
}
