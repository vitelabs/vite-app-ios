//
//  DebugService.swift
//  Vite
//
//  Created by Stone on 2018/10/23.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

class DebugService: Mappable {
    static let instance = DebugService()
    fileprivate let fileHelper = FileHelper(.library, appending: FileHelper.appPathComponent)
    fileprivate static let saveKey = "DebugService"


    var rpcUseHTTP = false {
        didSet {
            guard rpcUseHTTP != oldValue else { return }
            pri_save()
        }
    }


    var showStatisticsToast = false {
        didSet {
            guard showStatisticsToast != oldValue else { return }
            pri_save()
        }
    }

    var reportEventInDebug = false {
        didSet {
            guard reportEventInDebug != oldValue else { return }
            pri_save()
        }
    }

    required init?(map: Map) {}

    func mapping(map: Map) {
        rpcUseHTTP <- map["rpcUseHTTP"]
        showStatisticsToast <- map["showStatisticsToast"]
        reportEventInDebug <- map["reportEventInDebug"]
    }

    private init() {

        if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let d = DebugService(JSONString: jsonString) {
            self.rpcUseHTTP = d.rpcUseHTTP
            self.showStatisticsToast = d.showStatisticsToast
            self.reportEventInDebug = d.reportEventInDebug
        }
    }

    fileprivate func pri_save() {
        if let data = self.toJSONString()?.data(using: .utf8) {
            do {
                try fileHelper.writeData(data, relativePath: type(of: self).saveKey)
            } catch let error {
                assert(false, error.localizedDescription)
            }
        }
    }
}
