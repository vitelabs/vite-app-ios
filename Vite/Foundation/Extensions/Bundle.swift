//
//  Bundle.swift
//  Vite
//
//  Created by Water on 2018/9/21.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
    }
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "-1"
    }

    var buildNumberInt: Int {
        return Int(Bundle.main.buildNumber) ?? -1
    }

    var fullVersion: String {
        let versionNumber = Bundle.main.versionNumber
        let buildNumber = Bundle.main.buildNumber
        return "\(versionNumber) (\(buildNumber))"
    }
}

var isDebug: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}
