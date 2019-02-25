//
//  main.swift
//  Vite
//
//  Created by Water on 2019/1/24.
//  Copyright © 2019 vite labs. All rights reserved.
//
import Foundation
import UIKit

autoreleasepool {
    #if !(DEBUG)
    disable_gdb()
    #endif
    UIApplicationMain(
        CommandLine.argc, CommandLine.unsafeArgv,
        nil, NSStringFromClass(AppDelegate.self)
    )
}
