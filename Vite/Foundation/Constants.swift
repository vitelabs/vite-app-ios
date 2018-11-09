//
//  Constants.swift
//  Vite
//
//  Created by Water on 2018/9/21.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

public struct Constants {

    public enum Channel: String {
        case appstore
        case enterprise
    }

    // support
    public static let supportEmail = "info@vite.org"
    //baidu  statistics
    public static let baiduMobileStat = "e74c7f32c0"
    //app channel
    #if RELEASE_INHOUSE_FOR_DISTRIBUTE
    public static let appDownloadChannel = Channel.enterprise
    #else
    public static let appDownloadChannel = Channel.appstore
    #endif
    public static let quotaDefinitionURL = "https://app.vite.net/quotaDefinition"
    public static let voteDefinitionURL = "https://app.vite.net/vote"
    public static let voteLoserURL = "https://app.vite.net/vote"
}
