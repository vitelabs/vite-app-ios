//
//  Log.swift
//  Vite
//
//  Created by Stone on 2018/10/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import XCGLogger

enum Tag: String {
    case life
    case transaction
    case server
    case getConfig
    case vote
}

func plog(level: XCGLogger.Level, log: @escaping @autoclosure () -> Any?, tag: Tag, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    return plog(level: level, log: log, tags: [tag], functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

func plog(level: XCGLogger.Level, log: @escaping @autoclosure () -> Any?, tags: [Tag] = [], functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {

    let closure = { () -> String in
        let text = log() ?? ""
        var pre = tags.reversed().reduce("", { (result, tag) -> String in
            "\(tag) | \(result)"
        })
        if tags.isEmpty {
            pre = "NOTAG | "
        }
        return "\(pre)\(text)"
    }

    __log.logln(level, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: [:], closure: closure)
}

private let __log: XCGLogger = {
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
    dateFormatter.locale = Locale.current
    log.dateFormatter = dateFormatter

    let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")

    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = false
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true
    systemDestination.showDate = true
    log.add(destination: systemDestination)

    let cachePath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
    let logURL = cachePath.appendingPathComponent("logger.log")

    let fileDestination = FileDestination(writeToFile: logURL, identifier: "advancedLogger.fileDestination", shouldAppend: true, appendMarker: "-- Relauched App --")
    fileDestination.showLogIdentifier = false
    fileDestination.showFunctionName = true
    fileDestination.showThreadName = false
    fileDestination.showLevel = true
    fileDestination.showFileName = true
    fileDestination.showLineNumber = true
    fileDestination.showDate = true

    #if DEBUG
    fileDestination.outputLevel = .debug
    #elseif TEST
    fileDestination.outputLevel = .debug
    fileDestination.logQueue = XCGLogger.logQueue
    #else
    fileDestination.outputLevel = .info
    fileDestination.logQueue = XCGLogger.logQueue
    #endif

    log.add(destination: fileDestination)
    log.logAppDetails()
    return log
}()
