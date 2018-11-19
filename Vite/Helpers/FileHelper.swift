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
    private let queue = DispatchQueue(label: "net.vite.file.helper")

    public init(_ pathType: PathType = .library, appending pathComponent: String? = nil, createDirectory: Bool = true) {
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

        if createDirectory {
            rootPath = (rootPath as NSString).appendingPathComponent(Bundle.main.bundleIdentifier ?? "FileHelper") as String
        }

        if let component = pathComponent, !component.isEmpty {
            rootPath = (rootPath as NSString).appendingPathComponent(component) as String
        }

        fileManager = FileManager()
    }

    public func writeData(_ data: Data, relativePath: String) -> Error? {
        var error: Error?

        queue.sync {
            if relativePath.isEmpty {
                error = FileError.pathEmpty
            }

            let path = (rootPath as NSString).appendingPathComponent(relativePath) as String
            let dirPath = (path as NSString).deletingLastPathComponent as String

            if !fileManager.fileExists(atPath: dirPath) {
                do {
                    try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
                } catch let e {
                    error = e
                }

            }

            let tmpPath = path + ".__tmp__"
            if !fileManager.createFile(atPath: tmpPath, contents: data, attributes: nil) {
                error = FileError.createFileFailed
            }

            try? fileManager.removeItem(atPath: path)

            do {
                try fileManager.moveItem(atPath: tmpPath, toPath: path)
            } catch let e {
                error = e
            }
        }

        return error
    }

    public func moveFileAtPath(_ srcPath: String, to dstRelativePath: String) -> Error? {
        var error: Error?
        queue.sync {
            if srcPath.isEmpty ||
                dstRelativePath.isEmpty {
                error = FileError.pathEmpty
            }

            let path = (rootPath as NSString).appendingPathComponent(dstRelativePath) as String
            let dirPath = (path as NSString).deletingLastPathComponent as String

            if !fileManager.fileExists(atPath: dirPath) {
                do {
                    try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
                } catch let e {
                    error = e
                }
            }

            try? fileManager.removeItem(atPath: path)
            do {
                try fileManager.moveItem(atPath: srcPath, toPath: path)
            } catch let e {
                error = e
            }
        }
        return error
    }

    public func deleteFileAtRelativePath(_ path: String) -> Error? {
        var error: Error?
        queue.sync {
            let path = (rootPath as NSString).appendingPathComponent(path) as String
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch let e {
                    error = e
                }
            }
        }
        return error
    }

    public func contentsAtRelativePath(_ path: String) -> Data? {
        var data: Data?
        queue.sync {
            let path = (rootPath as NSString).appendingPathComponent(path) as String
            data = fileManager.contents(atPath: path)
        }
        return data
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
