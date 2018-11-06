//
//  Bundle.swift
//  Vite
//
//  Created by Water on 2018/9/21.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

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

    static func getObject<O: Mappable>(forResource name: String?, withExtension ext: String? = nil) -> O? {
        guard let path = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: nil, localization: nil)?.path else {
            return nil
        }
        guard FileManager.default.fileExists(atPath: path) else { return nil }
        guard let string = try? String(contentsOfFile: path) else { return nil }
        guard let ret = O(JSONString: string) else { return nil }
        return ret
    }
}

var isDebug: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}
