//
//  Constants.swift
//  Vite
//
//  Created by Water on 2018/9/21.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

public struct Constants {
    // support
    public static let supportEmail = "info@vite.org"
    //baidu  statistics
    public static let baiduMobileStat = "e74c7f32c0"
    //vite  centralized  host
    #if DEBUG
    public static let viteCentralizedHost = "http://testnet.vite.net"
    #else
    public static let viteCentralizedHost = "https://testnet.vite.net"
    #endif
    //app channel
    #if RELEASE_INHOUSE_FOR_DISTRIBUTE
    public static let appDownloadChannel = "enterprise"
    #else
    public static let appDownloadChannel = "appstore"
    #endif
    public static let quotaDefinitionURL = "https://app.vite.net/quotaDefinition"
    public static let voteDefinitionURL = "https://app.vite.net/vote"
    public static let voteLoserURL = "https://app.vite.net/vote"
}
