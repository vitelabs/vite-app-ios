//
//  RPCError.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

enum RPCError<ExpectedType>: Error {
    case responseTypeNotMatch(actualValue: Any, expectedType: ExpectedType.Type)
}

enum JSONError: Error {
    case jsonData
}
