//
//  FileHelper.swift
//  Vite
//
//  Created by Stone on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

public class FileHelper: NSObject {

    public enum FileError: Error {
        case pathEmpty
        case createFileFailed
    }

    public enum PathType {
        case documents
        case library
        case tmp
        case caches
        case appGroup(identifier: String)
    }

    public fileprivate(set) var rootPath: String
    var fileManager: FileManager

    public init(_ pathType: PathType = .library, appending pathComponent: String? = nil, createFDSDirectory: Bool = true) {
        switch pathType {
        case .documents:
            rootPath = FileHelper.documentsPath
        case .library:
            rootPath = FileHelper.libraryPath
        case .tmp:
            rootPath = FileHelper.tmpPath
        case .caches:
            rootPath = FileHelper.cachesPath
        case .appGroup(let identifier):
            rootPath = (FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)?.path)!
        }

        if createFDSDirectory {
            rootPath = (rootPath as NSString).appendingPathComponent(Bundle.main.bundleIdentifier ?? "FileHelper") as String
        }

        if let component = pathComponent, !component.isEmpty {
            rootPath = (rootPath as NSString).appendingPathComponent(component) as String
        }

        fileManager = FileManager()
    }

    public func writeData(_ data: Data, relativePath: String) throws {

        if relativePath.isEmpty {
            throw FileError.pathEmpty
        }

        let path = (rootPath as NSString).appendingPathComponent(relativePath) as String
        let dirPath = (path as NSString).deletingLastPathComponent as String

        if !fileManager.fileExists(atPath: dirPath) {
            try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }

        let tmpPath = path + ".__tmp__"
        if !fileManager.createFile(atPath: tmpPath, contents: data, attributes: nil) {
            throw FileError.createFileFailed
        }

        try? fileManager.removeItem(atPath: path)
        try fileManager.moveItem(atPath: tmpPath, toPath: path)
    }

    public func moveFileAtPath(_ srcPath: String, to dstRelativePath: String) throws {

        if srcPath.isEmpty ||
            dstRelativePath.isEmpty {
            throw FileError.pathEmpty
        }

        let path = (rootPath as NSString).appendingPathComponent(dstRelativePath) as String
        let dirPath = (path as NSString).deletingLastPathComponent as String

        if !fileManager.fileExists(atPath: dirPath) {
            try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }

        try? fileManager.removeItem(atPath: path)
        try fileManager.moveItem(atPath: srcPath, toPath: path)
    }

    public func deleteFileAtRelativePath(_ path: String) throws {
        let path = (rootPath as NSString).appendingPathComponent(path) as String

        if fileManager.fileExists(atPath: path) {
            try fileManager.removeItem(atPath: path)
        }
    }

    public func contentsAtRelativePath(_ path: String) -> Data? {
        let path = (rootPath as NSString).appendingPathComponent(path) as String
        return fileManager.contents(atPath: path)
    }
}

extension FileHelper {

    public static var documentsPath: String = {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }()

    public static var libraryPath: String = {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
    }()

    public static var tmpPath: String = {
        return NSTemporaryDirectory()
    }()

    public static var cachesPath: String = {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }()
}

extension FileHelper {
    static var appPathComponent = "app"
    // TODO: need account UUID
    static var accountPathComponent = "Account_UUID"
}
