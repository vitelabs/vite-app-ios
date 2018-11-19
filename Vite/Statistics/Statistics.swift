//
//  Statistics.swift
//  Vite
//
//  Created by Stone on 2018/10/23.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Statistics {

    private static let stat = BaiduMobStat.default()!

    static func initialize() {
        stat.channelId = Constants.appDownloadChannel.rawValue
        stat.shortAppVersion  =  Bundle.main.versionNumber
        stat.userId = stat.getDeviceCuid()
        stat.start(withAppId: Constants.baiduMobileStat)
    }

    static func log(eventId: String, attributes: [String: String] = [:]) {
        #if DEBUG || TEST
        if DebugService.instance.showStatisticsToast {
            if attributes.isEmpty {
                Toast.show("Statistics Event Start: \(eventId)")
            } else {
                if let data = try? JSONSerialization.data(withJSONObject: attributes, options: []),
                    let str = String(data: data, encoding: String.Encoding.utf8) {
                    Toast.show("Statistics Event Start: \(eventId)\nAttributes: \(str)")
                } else {
                    Toast.show("Statistics Event Start: \(eventId)\nAttributes Invalid")
                }
            }
        }

        if DebugService.instance.reportEventInDebug {
            if attributes.isEmpty {
                stat.logEvent(eventId, eventLabel: eventId)
            } else {
                stat.logEvent(eventId, eventLabel: eventId, attributes: attributes)
            }
        }

        #else
        if attributes.isEmpty {
            stat.logEvent(eventId, eventLabel: eventId)
        } else {
            stat.logEvent(eventId, eventLabel: eventId, attributes: attributes)
        }
        #endif

    }

    static func pageviewStart(with name: String) {
        #if DEBUG || TEST
        if DebugService.instance.showStatisticsToast {
            Toast.show("Statistics Page Start: \(name)")
        }

        if DebugService.instance.reportEventInDebug {
            stat.pageviewStart(withName: name)
            stat.logEvent(name, eventLabel: name)
        }
        #else
        stat.pageviewStart(withName: name)
        stat.logEvent(name, eventLabel: name)
        #endif
    }

    static func pageviewEnd(with name: String) {
        #if DEBUG || TEST
        if DebugService.instance.showStatisticsToast {
            Toast.show("Statistics Page End: \(name)")
        }

        if DebugService.instance.reportEventInDebug {
            stat.pageviewEnd(withName: name)
        }
        #else
        stat.pageviewEnd(withName: name)
        #endif
    }
}
